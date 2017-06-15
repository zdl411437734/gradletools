### Android上传到Jcenter仓库
1、在工程根目录build.gradle中添加

    //添加下面两行
    classpath 'com.github.dcendents:android-maven-gradle-plugin:1.5'
    classpath 'com.jfrog.bintray.gradle:gradle-bintray-plugin:1.7.3'

    查询最新插件替换
    插件地址
    https://github.com/dcendents/android-maven-gradle-plugin
    gradle插件地址
    http://jcenter.bintray.com/com/jfrog/bintray/gradle/gradle-bintray-plugin/


2、在项目build.gradle中添加

    //添加这两行
    apply plugin: 'com.github.dcendents.android-maven'
    apply plugin: 'com.jfrog.bintray'

    Properties properties = new Properties();
    properties.load(project.file('config.properties').newDataInputStream());
    def BINTRAY_USERNAME =properties.getProperty("bintray.username")
    def BINTRAY_APIKEY =properties.getProperty("bintray.apikey")
    def ARTIFACT_ID = properties.getProperty("artifact_id")
    def VERSION_NAME = properties.getProperty("version.name")
    def VERSION_DESC = properties.getProperty("version.desc")
    def VERSION_VCSTAG = properties.getProperty("version.vcsTag")
    def GROUP_ID = properties.getProperty("group_id")
    def siteUrl = properties.getProperty("siteUrl")
    def gitUrl = properties.getProperty("gitUrl")
    def id = properties.getProperty("dev.id")
    def devName = properties.getProperty("dev.name")
    def devEmail = properties.getProperty("dev.email")



    group = GROUP_ID
    version = VERSION_VCSTAG

    install {
        repositories.mavenInstaller {
            pom {
                project {
                    packaging 'aar'
                    name ARTIFACT_ID
                    url siteUrl
                    licenses {
                        license {
                            name 'The Apache Software License, Version 2.0'
                            url 'http://www.apache.org/licenses/LICENSE-2.0.txt'
                        }
                    }

                    developers {
                        developer {
                            id  id
                            name devName
                            email devEmail
                        }
                    }

                    scm {
                        connection gitUrl
                        developerConnection gitUrl
                        url siteUrl
                    }
                }

            }
        }
    }



    bintray {
        user = BINTRAY_USERNAME   //读取 local.properties 文件里面的 bintray.user 登录用户名。
        key = BINTRAY_APIKEY   //读取 local.properties 文件里面的 bintray.apikey
        configurations = ['archives']
        pkg {
            //这里的repo值必须要和你创建Maven仓库的时候的名字一样
            repo = "maven"
            //发布到JCenter上的项目名字
            name = ARTIFACT_ID
             //项目官网地址
            websiteUrl = siteUrl
            //指定项目git地址
            vcsUrl = gitUrl
            licenses = ["Apache-2.0"]
            publish = true //是否是公开项目。
            version {
                        name = VERSION_NAME //版本名称
                        desc = VERSION_DESC //版本描述
                        released  =new Date() //上传过程中如果此处报错，可以注释掉此句
                        vcsTag = VERSION_VCSTAG //版本
                    }
        }
    }

    //解决javadoc中文问题
    tasks.withType(Javadoc) {
        options.addStringOption('Xdoclint:none', '-quiet')
        options.addStringOption('encoding', 'UTF-8')
        options.addStringOption('charSet', 'UTF-8')
    }

    task androidJavadocs(type: Javadoc) {
        source = android.sourceSets.main.java.srcDirs
        classpath += project.files(android.getBootClasspath().join(File.pathSeparator))
    }

    task androidJavadocsJar(type: Jar, dependsOn: androidJavadocs) {
        classifier = 'javadoc'
        from androidJavadocs.destinationDir
    }

    task androidSourcesJar(type: Jar) {
        classifier = 'sources'
        from android.sourceSets.main.java.srcDirs
    }

    artifacts {
        archives androidSourcesJar
        archives androidJavadocsJar
    }

或者下载jcenter.gradle 在build中使用 apply from:'nexusBintry.gradle'
或者直接在build中使用


     apply from:'https://coding.net/u/zdl_411437734/p/gradle/git/raw/master/jcenter.gradle'


3、在config.properties添加jcenter用户名和key

     # 上传到Jcenter配置
    bintray.username= bintray注册的用户名
    bintray.apikey= bintray 中 apikey
    artifact_id =
    group_id =
    siteUrl =
    gitUrl =
    dev.id =
    dev.name =
    dev.email =
    version.name =
    version.desc =
    version.vcsTag =

    #例如
    #bintray.username = bintray用户名
    #bintray.apikey = apikey
    #artifact_id = 项目名称
    #group_id =  项目包名
    #siteUrl = 网站url
    #gitUrl = giturl
    #dev.id = 开发者id 自己随便写
    #dev.name = 开发者名称
    #dev.email = 开发者email
    #version.name = 版本名称-一般写版本号"1.0.0"
    #version.desc = 版本描述
    #version.vcsTag =  版本标签一般写 版本号"1.0.0"


4、在项目中执行

    gradle assembleRelease  bintrayUpload