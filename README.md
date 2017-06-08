# Android开发中Gradle配置使用


![](https://img.shields.io/badge/AnroidGradleTools-V1.0.0-green.svg)
#####前言
> <font size="2">每次创建私有项目都需要配置gradle文件，没什么技术含量，还要多劳动（程序员就是懒），为了能方便使用，才有了本仓库的诞生。
> 欢迎各位小伙伴们来砸场，喜欢请star下...</font>

### 私有仓库使用
1. 在下载config.properties文件放到工厂根目录（和gradle.properties同级）
2. 如果使用Artifactory仓库配置工程build.gradle文件请看详细文件
3. 在项目build.gradle文件中使用

```
apply from:'https://coding.net/u/zdl_411437734/p/gradle/git/raw/master/nexusBintry.gradle'
    或者
apply from:'https://coding.net/u/zdl_411437734/p/gradle/git/raw/master/artifactBintry.gradle'
```
4. 执行相关命令即可

```
gradle uploadArchives （nexus仓库）
或者
gradle assembleRelease artifactoryPublish (artifactory仓库)

```

[详细使用文档](https://coding.net/u/zdl_411437734/p/gradle/git/blob/master/Maven.md)

### Sonarqube使用
[详细使用文档](https://coding.net/u/zdl_411437734/p/gradle/git/blob/master/SONARQUBE.md)

### pack（打包）使用
> <font size="2">经常打包apk，有一个困扰，怎么修改打包后的名称，怎么区分打包的是release版本还是debug版本，想了解请继续看</font>

1. 在项目的buil.gradle文件配置打包的版本和输出的名称

```
//打包APK根据不同的环境打包不同的名称
ext{
    productName = project.name
    versionName = "1.0.1"
}
//productName 打包出来的名称
//versionName 打包显示版本号
```
2 . 引入packe.gradle文件[下载packe.gradle](http://zdl_411437734.coding.me/gradle/pack.gradle)

```
apply from:"./pack.gradle"
或者
apply from:"https://coding.net/u/zdl_411437734/p/gradle/git/raw/master/pack.gradle"
```
3 . 打包即可（~~）

### sign（签名）使用
> <font size="2">有时候，在集成第三方时候，需要我们输入签名，在开发中和发布中一般默认都是2个keystroe，在这种情况下，开发很不方便，不断要打包成正式包才能测试，为了解决这个问题，我们配置gradle在开发时就使用正式签名开发，想了解请继续看</font>

1. 在项目的buil.gradle文件配置打包的版本和输出的名称

```
//打包APK根据不同的环境打包不同的名称
ext{
    productName = "CommonProject"
    versionName = "2.0.1"
    keyPassword = "android"
    keyFilePath = "/Users/jason/Documents/keystore/android.keystore"
    storePassword = "android"
    keyAlias = "android"
}

//productName 打包出来的名称
//versionName 打包显示版本号
//keyPassword 密码
//keyFilePath 正式全路径
//storePassword 密码
//keyAlias 别名
```
2 . 引入sign.gradle文件[下载sign.gradle](http://zdl_411437734.coding.me/gradle/sign.gradle)

```
apply from:"./sign.gradle"
或者
apply from:"https://coding.net/u/zdl_411437734/p/gradle/git/raw/master/sign.gradle"
```
3 . 配置项目中build.gradle文件

```
buildTypes {
    release {
        signingConfig signingConfigs.releaseConfig
    }

    debug {
        signingConfig signingConfigs.debugConfig
    }
}
//在 android{}中配置buildTypes
```

### 配置文件
><font size="2">不想使用提供的在线的文件配置，请自行copy下面的内容放入自己的工程中 </font>
>

artifactory仓库使用配置文件[artifactBintry.gradle](https://coding.net/u/zdl_411437734/p/gradle/git/raw/master/artifactBintry.gradle)  [下载](http://zdl_411437734.coding.me/gradle/artifactBintry.gradle)


Nexus参考配置文件[nexusBintry.gradle](https://coding.net/u/zdl_411437734/p/gradle/git/raw/master/nexusBintry.gradle)  [下载](http://zdl_411437734.coding.me/gradle/nexusBintry.gradle)


Config.properties配置文件[config.properties](https://coding.net/u/zdl_411437734/p/gradle/git/raw/master/config.properties)  [下载](http://zdl_411437734.coding.me/gradle/config.properties)


Nexus仓库配置文件(简易版)[bintray.gradle](https://coding.net/u/zdl_411437734/p/gradle/git/raw/master/bintray.gradle)  [下载](http://zdl_411437734.coding.me/gradle/bintray.gradle)


Sonarqube配置文件[sonarqube.gradle](https://coding.net/u/zdl_411437734/p/gradle/git/raw/master/sonarqube.gradle)  [下载](http://zdl_411437734.coding.me/gradle/sonarqube.gradle)

pack配置文件[pack.gradle](https://coding.net/u/zdl_411437734/p/gradle/git/raw/master/pack.gradle)  [下载](http://zdl_411437734.coding.me/gradle/pack.gradle)

sign配置文件[sign.gradle](https://coding.net/u/zdl_411437734/p/gradle/git/raw/master/sign.gradle)  [下载](http://zdl_411437734.coding.me/gradle/sign.gradle)



###联系我们
Email:411437734@qq.com

个人博客：[http://www.etongwl.com](http://www.etongwl.com)

