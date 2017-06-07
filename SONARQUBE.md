# SonarQube Android studio使用
### 配置工程的build.gradle文件
1. 在repositories中配置maven仓库 
 
		 maven {
	            url "https://plugins.gradle.org/m2/"
	        }

2. 在dependencies中配置	

		classpath "org.sonarsource.scanner.gradle:sonarqube-gradle-plugin:2.5-rc1"
	 
3. 在gradle.properties文件配置（地址自己地址）
	
		systemProp.sonar.host.url=http://192.168.0.251:9000
		
		
4. 在项目build.gradle中配置

		apply plugin: 'org.sonarqube'
		sonarqube {
			 properties {
			        property "sonar.projectBaseDir", "${project.rootDir}/${project.name}/"
			        property "sonar.host.url", "http://192.168.0.251:9000"
			        property "sonar.login", "admin"
			        property "sonar.password", "admin"
			        property "sonar.exclusions", "**/exclude/**"
			        property "sonar.sources", "${project.rootDir}/${project.name}/src/main/java"
			        property "sonar.binaries", "$project.buildDir/intermediates/classes/"
			        property "sonar.projectKey", "sdk:${project.name}"
			        property "sonar.projectName", project.name
			        property "sonar.projectVersion", "1.0.0"
			        property "sonar.projectDescription", project.name
			        property "sonar.scm.disabled",true
        	}
        }
        
        
5. 在android studio中命令行 执行 gradle sonarqube 任务即可完成。（完成后查看Sonar项目分析完成并上传）