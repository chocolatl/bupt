# 仿北邮官网

网页制作课设，没啥好说的。

## 部署

1. 执行 `npm install` 安装依赖项
2. 执行 `npm run build` , 将会完成以下任务：
    1. 编译Less到 `build/stylesheets`
    2. 编译Coffee到 `build/javascripts`
    3. 复制img到 `build/images`
3. 执行 `node index.js` , 生成静态页面到`public`

`public`目录为站点根目录

注：仅支持Windows

## 兼容性

IE10+、Chrome、Firefox

注：IE9不兼容的原因为生成的静态页面使用了相对路径的`<base>`

## 配置子页面

子页面配置数据存放在：`views/data/subpages.json` 中

填充子页面的示例见 `subpages.json` 中的：北邮概况->走进北邮->学校简介

CSS可以写在 `less/art-content.less` 中

配置完成后重新部署

## 演示地址

<https://chocolatl.github.io/bupt/>
