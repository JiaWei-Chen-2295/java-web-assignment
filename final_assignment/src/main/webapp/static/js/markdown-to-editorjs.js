/**
 * Markdown / Editor.js JSON 转换与 List v2 数据迁移
 */
(function (global) {
    'use strict';

    function emptyDoc() {
        return {
            time: Date.now(),
            blocks: [{ type: 'paragraph', data: { text: '' } }],
            version: '2.28.0'
        };
    }

    /** List v2 单项结构 */
    function listItem(content, meta) {
        return {
            content: content || '',
            meta: meta || {},
            items: []
        };
    }

    function isEditorJsData(obj) {
        return obj && Array.isArray(obj.blocks);
    }

    /** 将 v1 列表 / 独立 checklist 块迁移为 List v2 */
    function migrateBlock(block) {
        if (!block || !block.type) return block;

        if (block.type === 'checklist' && block.data && block.data.items) {
            return {
                type: 'list',
                data: {
                    style: 'checklist',
                    items: block.data.items.map(function (it) {
                        return listItem(it.text || '', { checked: !!it.checked });
                    })
                }
            };
        }

        if (block.type === 'list' && block.data && Array.isArray(block.data.items)) {
            if (block.data.items.length === 0) {
                block.data.items = [listItem('', {})];
            } else if (typeof block.data.items[0] === 'string') {
                block.data.items = block.data.items.map(function (t) {
                    return listItem(String(t), {});
                });
            }
            if (!block.data.style) {
                block.data.style = 'unordered';
            }
        }

        return block;
    }

    function normalizeDoc(data) {
        if (!data || !data.blocks) return data;
        data.blocks = data.blocks.map(migrateBlock);
        return data;
    }

    function parseEditorJsString(str) {
        if (!str || !str.trim()) return emptyDoc();
        try {
            var parsed = JSON.parse(str);
            if (isEditorJsData(parsed)) return normalizeDoc(parsed);
        } catch (e) { /* markdown */ }
        return normalizeDoc(markdownToEditorJs(str));
    }

    function markdownToEditorJs(md) {
        if (!md || !md.trim()) return emptyDoc();

        var blocks = [];
        var lines = md.replace(/\r\n/g, '\n').split('\n');
        var i = 0;
        var inCode = false;
        var codeBuf = [];

        while (i < lines.length) {
            var line = lines[i];

            if (line.trim().startsWith('```')) {
                if (inCode) {
                    blocks.push({ type: 'code', data: { code: codeBuf.join('\n') } });
                    codeBuf = [];
                    inCode = false;
                } else {
                    inCode = true;
                }
                i++;
                continue;
            }
            if (inCode) {
                codeBuf.push(line);
                i++;
                continue;
            }

            if (/^---+$/.test(line.trim())) {
                blocks.push({ type: 'delimiter', data: {} });
                i++;
                continue;
            }

            var hm = line.match(/^(#{1,6})\s+(.+)/);
            if (hm) {
                blocks.push({
                    type: 'header',
                    data: { text: hm[2].trim(), level: Math.min(6, hm[1].length) }
                });
                i++;
                continue;
            }

            if (/^>\s?/.test(line)) {
                var quoteLines = [];
                while (i < lines.length && /^>\s?/.test(lines[i])) {
                    quoteLines.push(lines[i].replace(/^>\s?/, ''));
                    i++;
                }
                blocks.push({ type: 'quote', data: { text: quoteLines.join('\n'), caption: '' } });
                continue;
            }

            if (/^!\[([^\]]*)\]\(([^)]+)\)/.test(line.trim())) {
                var im = line.trim().match(/^!\[([^\]]*)\]\(([^)]+)\)/);
                blocks.push({
                    type: 'image',
                    data: { file: { url: im[2] }, caption: im[1] || '', withBorder: false, stretched: false, withBackground: false }
                });
                i++;
                continue;
            }

            if (/^-\s+\[[ xX]\]\s+/.test(line)) {
                var checkItems = [];
                while (i < lines.length && /^-\s+\[[ xX]\]\s+/.test(lines[i])) {
                    var cm = lines[i].match(/^-\s+\[([ xX])\]\s+(.+)/);
                    checkItems.push(listItem(cm[2], { checked: cm[1].toLowerCase() === 'x' }));
                    i++;
                }
                blocks.push({ type: 'list', data: { style: 'checklist', items: checkItems } });
                continue;
            }

            if (/^[-*]\s+/.test(line)) {
                var uItems = [];
                while (i < lines.length && /^[-*]\s+/.test(lines[i])) {
                    uItems.push(listItem(lines[i].replace(/^[-*]\s+/, ''), {}));
                    i++;
                }
                blocks.push({ type: 'list', data: { style: 'unordered', items: uItems } });
                continue;
            }

            if (/^\d+\.\s+/.test(line)) {
                var oItems = [];
                while (i < lines.length && /^\d+\.\s+/.test(lines[i])) {
                    oItems.push(listItem(lines[i].replace(/^\d+\.\s+/, ''), {}));
                    i++;
                }
                blocks.push({
                    type: 'list',
                    data: { style: 'ordered', meta: { start: 1, counterType: 'numeric' }, items: oItems }
                });
                continue;
            }

            if (line.trim() === '') {
                i++;
                continue;
            }

            var para = [line];
            i++;
            while (i < lines.length && lines[i].trim() !== '' && !/^(#{1,6})\s/.test(lines[i])
                && !/^>\s?/.test(lines[i]) && !/^```/.test(lines[i])
                && !/^[-*]\s+/.test(lines[i]) && !/^\d+\.\s+/.test(lines[i])
                && !/^-\s+\[[ xX]\]\s+/.test(lines[i]) && !/^---+$/.test(lines[i].trim())) {
                para.push(lines[i]);
                i++;
            }
            blocks.push({ type: 'paragraph', data: { text: para.join('\n') } });
        }

        if (blocks.length === 0) {
            return emptyDoc();
        }
        return { time: Date.now(), blocks: blocks, version: '2.28.0' };
    }

    function extractListItemsRecursive(items, parts) {
        if (!items || !items.length) return;
        items.forEach(function (it) {
            if (typeof it === 'string') {
                parts.push(it);
            } else if (it && it.content !== undefined) {
                parts.push(it.content);
                if (it.items && it.items.length) {
                    extractListItemsRecursive(it.items, parts);
                }
            }
        });
    }

    function extractPlainText(data) {
        if (!data || !data.blocks) return '';
        var parts = [];
        data.blocks.forEach(function (b) {
            var d = b.data || {};
            switch (b.type) {
                case 'header':
                case 'paragraph':
                case 'quote':
                    parts.push(stripTags(d.text || ''));
                    break;
                case 'code':
                    parts.push(d.code || '');
                    break;
                case 'list':
                case 'checklist':
                    extractListItemsRecursive(d.items, parts);
                    break;
                default:
                    if (d.text) parts.push(stripTags(d.text));
            }
        });
        return parts.map(function (p) { return stripTags(String(p)); }).join(' ');
    }

    function stripTags(html) {
        var el = document.createElement('div');
        el.innerHTML = html;
        return el.textContent || '';
    }

    global.MarkdownToEditorJs = {
        emptyDoc: emptyDoc,
        listItem: listItem,
        migrateBlock: migrateBlock,
        normalizeDoc: normalizeDoc,
        parse: parseEditorJsString,
        fromMarkdown: markdownToEditorJs,
        extractPlainText: extractPlainText,
        isEditorJsData: isEditorJsData
    };
})(window);
