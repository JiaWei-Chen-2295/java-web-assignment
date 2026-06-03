# Editor.js 本地资源

由 `npm install` 后从 `node_modules/@editorjs/*/dist/*.umd.js` 复制而来。

## 当前版本

| 文件 | 包 | 版本 |
|------|-----|------|
| editorjs.min.js | @editorjs/editorjs | 2.30.8 |
| header.min.js | @editorjs/header | 2.8.8 |
| **list.min.js** | **@editorjs/list** | **2.0.8**（全局 `EditorjsList`，List v2） |
| code.min.js | @editorjs/code | 2.9.3 |
| image.min.js | @editorjs/image | 2.9.0 |
| quote.min.js | @editorjs/quote | 2.6.0 |
| delimiter.min.js | @editorjs/delimiter | 1.4.2 |

> 待办清单已合并进 List v2（`style: "checklist"`），不再单独加载 `checklist.min.js`。

## 更新 List v2

在 `final_assignment` 目录执行：

```bash
npm install --no-save @editorjs/list@2.0.8
copy node_modules\@editorjs\list\dist\editorjs-list.umd.js src\main\webapp\static\js\vendor\editorjs\list.min.js
```

## 更新全部插件

```bash
npm install --no-save @editorjs/editorjs@2.30.8 @editorjs/header@2.8.8 @editorjs/list@2.0.8 @editorjs/code@2.9.3 @editorjs/image@2.9.0 @editorjs/quote@2.6.0 @editorjs/delimiter@1.4.2
```

然后按 `note-editor.jsp` 中的引用，将各包 `dist/*.umd.js` 复制到本目录并重命名为 `*.min.js`。
