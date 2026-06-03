/**
 * EnhancedCodeTool — Editor.js 增强版代码块工具
 * 支持语言选择、自动高度、复制按钮、中文 placeholder
 * 数据模型: { code: string, language: string }
 * 向后兼容: 旧数据 { code } 无 language 字段时默认为空
 */
function EnhancedCodeTool(params) {
    'use strict';
    this.data = params.data || {};
    this.api = params.api;
    this.readOnly = params.readOnly || false;

    this.data.code = this.data.code || '';
    this.data.language = this.data.language || '';
}

EnhancedCodeTool.isReadOnlySupported = true;
EnhancedCodeTool.enableLineBreaks = true;

EnhancedCodeTool.DEFAULT_PLACEHOLDER = '输入代码...';

EnhancedCodeTool.LANGUAGES = [
    { value: '', label: '纯文本' },
    { value: 'javascript', label: 'JavaScript' },
    { value: 'python', label: 'Python' },
    { value: 'java', label: 'Java' },
    { value: 'html', label: 'HTML' },
    { value: 'css', label: 'CSS' },
    { value: 'sql', label: 'SQL' },
    { value: 'typescript', label: 'TypeScript' },
    { value: 'go', label: 'Go' },
    { value: 'cpp', label: 'C/C++' },
    { value: 'shell', label: 'Shell' },
    { value: 'json', label: 'JSON' },
    { value: 'xml', label: 'XML' },
    { value: 'yaml', label: 'YAML' },
    { value: 'markdown', label: 'Markdown' }
];

EnhancedCodeTool.toolbox = {
    icon: '<svg width="14" height="14" viewBox="0 0 14 14"><path d="M3.5 2L1 7l2.5 5M10.5 2L13 7l-2.5 5" stroke="currentColor" stroke-width="1.5" fill="none" stroke-linecap="round"/></svg>',
    title: '代码'
};

EnhancedCodeTool.sanitize = {
    code: true,
    language: {}
};

EnhancedCodeTool.pasteConfig = {
    tags: ['pre']
};

EnhancedCodeTool.prototype.render = function () {
    var wrapper = document.createElement('div');
    wrapper.className = 'enhanced-code';

    // --- Header row ---
    var header = document.createElement('div');
    header.className = 'enhanced-code__header';

    var langLabel = document.createElement('span');
    langLabel.className = 'enhanced-code__lang-label';
    langLabel.textContent = this._langDisplay(this.data.language);

    var langSelect = document.createElement('select');
    langSelect.className = 'enhanced-code__lang-select';
    langSelect.addEventListener('mousedown', function (e) {
        e.stopPropagation();
    });
    EnhancedCodeTool.LANGUAGES.forEach(function (lang) {
        var opt = document.createElement('option');
        opt.value = lang.value;
        opt.textContent = lang.label;
        if (lang.value === this.data.language) opt.selected = true;
        langSelect.appendChild(opt);
    }.bind(this));
    langSelect.addEventListener('change', function () {
        langLabel.textContent = this._langDisplay(langSelect.value);
    }.bind(this));

    var copyBtn = document.createElement('button');
    copyBtn.type = 'button';
    copyBtn.className = 'enhanced-code__copy-btn';
    copyBtn.title = '复制代码';
    copyBtn.innerHTML = '<i class="bi bi-clipboard"></i>';
    copyBtn.addEventListener('mousedown', function (e) { e.stopPropagation(); });
    copyBtn.addEventListener('click', function (e) {
        e.preventDefault();
        e.stopPropagation();
        var text = textarea.value;
        if (navigator.clipboard && navigator.clipboard.writeText) {
            navigator.clipboard.writeText(text).then(function () {
                copyBtn.innerHTML = '<i class="bi bi-clipboard-check"></i>';
                setTimeout(function () {
                    copyBtn.innerHTML = '<i class="bi bi-clipboard"></i>';
                }, 1500);
            });
        } else {
            // Fallback for older browsers
            var tmp = document.createElement('textarea');
            tmp.value = text;
            tmp.style.position = 'fixed';
            tmp.style.left = '-9999px';
            document.body.appendChild(tmp);
            tmp.select();
            document.execCommand('copy');
            document.body.removeChild(tmp);
            copyBtn.innerHTML = '<i class="bi bi-clipboard-check"></i>';
            setTimeout(function () {
                copyBtn.innerHTML = '<i class="bi bi-clipboard"></i>';
            }, 1500);
        }
    });

    header.appendChild(langLabel);
    header.appendChild(langSelect);
    header.appendChild(copyBtn);
    wrapper.appendChild(header);

    // --- Textarea ---
    var textarea = document.createElement('textarea');
    textarea.className = 'enhanced-code__textarea';
    textarea.placeholder = this.api && this.api.i18n
        ? this.api.i18n.t(EnhancedCodeTool.DEFAULT_PLACEHOLDER)
        : EnhancedCodeTool.DEFAULT_PLACEHOLDER;
    textarea.value = this.data.code;

    if (this.readOnly) {
        textarea.readOnly = true;
    }

    // Auto-height logic
    var autoResize = function () {
        textarea.style.height = 'auto';
        var h = Math.max(28, textarea.scrollHeight);
        textarea.style.height = h + 'px';
    };

    textarea.addEventListener('input', autoResize);

    wrapper.appendChild(textarea);

    // Set initial height after DOM is ready
    setTimeout(autoResize, 0);

    this._textarea = textarea;
    this._langSelect = langSelect;

    return wrapper;
};

EnhancedCodeTool.prototype.save = function (block) {
    var textarea = block.querySelector('.enhanced-code__textarea');
    var langSelect = block.querySelector('.enhanced-code__lang-select');
    return {
        code: textarea ? textarea.value : '',
        language: langSelect ? langSelect.value : ''
    };
};

EnhancedCodeTool.prototype.onPaste = function (event) {
    var pre = event.detail.data;
    if (!pre) return {};
    var code = pre.textContent || pre.innerHTML || '';
    // Extract language from class like "language-javascript"
    var language = '';
    if (pre.className) {
        var match = pre.className.match(/language-(\w+)/);
        if (match) language = match[1];
    }
    return {
        code: code,
        language: language
    };
};

EnhancedCodeTool.prototype._langDisplay = function (lang) {
    if (!lang) return '代码';
    var found = EnhancedCodeTool.LANGUAGES.filter(function (l) { return l.value === lang; });
    return found.length ? found[0].label : lang;
};