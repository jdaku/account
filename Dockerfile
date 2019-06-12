FROM tomcat:8.5.11-jre8
COPY ./target/account-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/account.war
