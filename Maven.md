# 私有Artifact/Nexus仓库配置

###Aritfact仓配配置
1. 在工程build.gradle文件中dependecies配置

        classpath "org.jfrog.buildinfo:build-info-extractor-gradle:4+"
        
        
2. 在项目（module）build.gradle文件中配置

        //解决javadoc中文问题
        tasks.withType(Javadoc) {
        options.addStringOption('Xdoclint:none', '-quiet')
        options.addStringOption('encoding', 'UTF-8')
        options.addStringOption('charSet', 'UTF-8')
        }
3. 在项目（module）build.gradle文件中配置
        
        apply from:'artifactBintry.gradle'
        或则 apply from:'http://xxxx/artifactBintry.gradle'
        
4. artifactBintry.gradle内容为

```
apply plugin: "com.jfrog.artifactory"
apply plugin: "maven-publish"

Properties properties = new Properties();
properties.load(project.rootProject.file('config.properties').newDataInputStream());
def ARTFACTORY_CONTEXTURL =properties.getProperty("artifactory_contextUrl")
def ARTFACTORY_REPOKEY =properties.getProperty("artifactory_repoKey")
def USER =properties.getProperty("artifactory_user")
def PWD =properties.getProperty("artifactory_password")
def ARTIFACT_ID = properties.getProperty("artifact_id")
def VERSION_NAME = properties.getProperty("version_name")
def GROUP_ID = properties.getProperty("group_id")

def packageName = GROUP_ID
def libraryVersion = VERSION_NAME


publishing {
    publications {
        aar(MavenPublication) {
            groupId packageName
            version = libraryVersion
            artifactId ARTIFACT_ID
            // Tell maven to prepare the generated “*.aar” file for publishing
            artifact("$buildDir/outputs/aar/${project.getName()}-release.aar")
            artifact androidJavadocsJar
            artifact androidSourcesJar
        }

    }
}

artifactory {
    contextUrl = ARTFACTORY_CONTEXTURL
    publish {
        repository {
            repoKey = ARTFACTORY_REPOKEY
            username = USER
            password = PWD
            maven = true
        }
        defaults {
            publications('aar')
            publishArtifacts = true

            properties = ['qa.level': 'basic', 'q.os': 'android', 'dev.team': 'core']
            publishPom = true
            maven = true
        }
    }
}


task androidJavadocs(type: Javadoc) {
    source = android.sourceSets.main.java.srcDirs
    classpath +=    project.files(android.getBootClasspath().join(File.pathSeparator))
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




```
5 . 在android studio的Terminal中输入 
  
```  
 gradle assembleRelease artifactoryPublish
```
执行成功就可以看到项目arr在你的私有仓库中。

### Nexus仓库配置

1. 在项目（module）build.gradle文件中配置

        //解决javadoc中文问题
        tasks.withType(Javadoc) {
        options.addStringOption('Xdoclint:none', '-quiet')
        options.addStringOption('encoding', 'UTF-8')
        options.addStringOption('charSet', 'UTF-8')
        }
2. 在项目（module）build.gradle文件中配置
        
        apply from:'nexusBintry.gradle'
        或则 apply from:'http://xxxx/nexusBintry.gradle'

3. nexusBintry.gradle内容为

```
apply plugin: 'maven-publish'
apply plugin: 'maven'


Properties properties = new Properties();
properties.load(project.rootProject.file('config.properties').newDataInputStream());
def MAVEN_LOCAL_PATH =properties.getProperty("nexus_contextUrl")
def USER =properties.getProperty("nexus_user")
def PWD =properties.getProperty("nexus_password")
def ARTIFACT_ID = properties.getProperty("artifact_id")
def VERSION_NAME = properties.getProperty("version_name")
def GROUP_ID = properties.getProperty("group_id")



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

uploadArchives {
    repositories {
        mavenDeployer {
            repository(url:MAVEN_LOCAL_PATH ){
                authentication(userName: USER, password:PWD)
            }
            pom.project {
                groupId GROUP_ID
                artifactId ARTIFACT_ID
                version VERSION_NAME
                packaging 'aar'
            }
        }
    }
}
```
4 . 在android studio的Terminal中输入 
  
```  
gradle uploadArchives
```
执行成功就可以看到项目arr在你的私有仓库中。

### 仓库引用
1. 在工程buid.gradle文件中配置如下内容

```
allprojects {
    repositories {
        jcenter()
        maven { url "http://xxxxxx"}
        maven { url 'http://xxxx:8081/nexus/content/repositories/releases/'}
        //maven { url 'http://api.oue-app.com/artifactory/libs-release-local/'}
    }
}
```
项目中就可以正常使用了


个人博客：[使用Artifactory搭建本地maven仓库](http://www.etongwl.com/blogphp/archives/1266.html)

