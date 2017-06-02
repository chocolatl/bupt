var fs = require('fs')
var ejs = require('ejs')
var path = require('path')

var buTabs = require('./views/data/bu-tabs.json')
var subpages = require('./views/data/subpages.json')

var helper = {
    getNavPath: function(nowPage) {
        var path = nowPage.route;
        while(nowPage.subpages) {
            nowPage = nowPage.subpages[0];
            path += '/' + nowPage.route;
        }
        return path + '.html'
    }
}

function makeDir(dirPath) {
    try {
        fs.accessSync(dirPath);
    }
    catch(e) {
        if(e.code === 'ENOENT') {
            fs.mkdirSync(dirPath);
        } else {
            throw e;
        }
    }
}

// makeRootUri('public/sub/about') or makeRootUri('public/sub/about/') 返回 ../../
function makeRootUri(dir) {
    if(dir.slice(-1) === path.sep) {
        dir = dir.slice(0, -1);
    }
    return dir.split(path.sep).slice(0, -1).fill("../").join('');
}

var rootPath = 'public';    // 根目录
var subpagesPath = 'public/subpages';   // 子页面路径
var subRelativePath = 'subpages';    // 去掉rootPath的子页面目录
makeDir(rootPath);
makeDir(subpagesPath);

// 生成首页
ejs.renderFile('views/index.ejs', {subRelativePath: subRelativePath, baseUri: '', subpages: subpages, buTabs: buTabs, footerFixed: true, helper: helper}, (err, str) => {
    if(err) throw err;

    fs.writeFile(rootPath + '/index.html', str, 'utf8', err => {
        if(err) throw err;
    });

});

// 生成子页面
for(var sub1 of subpages.subpages) {
    let nowDir = path.join(subpagesPath, sub1.route);
    makeDir(nowDir);

    for(var sub2 of sub1.subpages) {
        if(sub2.subpages) {
            let nowDir = path.join(subpagesPath, sub1.route, sub2.route);
            makeDir(nowDir);

            for(var sub3 of sub2.subpages) {
                ejs.renderFile('views/content.ejs', {subRelativePath: subRelativePath, baseUri: subpagesPath, rootUri: makeRootUri(nowDir), subpages: subpages, routes: [sub1, sub2, sub3], footerFixed: false, helper: helper}, (err, str) => {
                    if(err) throw err;
                    
                    fs.writeFile(path.join(subpagesPath, sub1.route, sub2.route, sub3.route + '.html'), str, 'utf8', err => {
                        if(err) throw err;
                    });
                });
            }
        } else {
            ejs.renderFile('views/content.ejs', {subRelativePath: subRelativePath, baseUri: subpagesPath, rootUri: makeRootUri(nowDir), subpages: subpages, routes: [sub1, sub2], footerFixed: false, helper: helper}, (err, str) => {
                if(err) throw err;
                
                fs.writeFile(path.join(subpagesPath, sub1.route, sub2.route + '.html'), str, 'utf8', err => {
                    if(err) throw err;
                });
            });
        }
    }
}
