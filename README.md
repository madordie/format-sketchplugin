## format-sketchplugin
 
 为Sketch自动生成自定义填充数据源插件。
 
![预览](https://github.com/madordie/format-sketchplugin/blob/master/Images/Untitled.gif?raw=true)
 
## 使用方法

- 下载[Release](https://github.com/madordie/format-sketchplugin/releases)上的包，并双击打开
- 选择要随机填充的文本数据(支持多选，文本数据按照回车进行随机，会默认删除空数据)
- 选择随机填充的图片文件夹(只支持单选文件夹，选中文件夹内的`.png`、 `.PNG`、 `.jpg`、 `.JPG`、 `.jpeg`、 `.JPEG`、 `.gif`、 `.GIF`文件将会被识别并作为数据源)
- 将插件生成目录拖拽至窗口即完成设置
- 文本、图片文件夹 可在保存前重复多次选择
- 点击`制作`，即可在生成目录看到插件生成

## 生成说明

- 文本数据按照文本文件名作为标示
- 图片文件夹按照图片文件夹名作为标示
- 保存时，文本数据会读取至插件内
- 保存时，图片文件夹会复制至插件内(不识别子目录，并只拷贝可识别的素材)
