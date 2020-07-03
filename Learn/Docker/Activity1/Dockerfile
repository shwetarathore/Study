FROM centos:7
WORKDIR /root/javacalcapp
COPY Calc.java /root/javacalcapp
ENV APP_HOME /root/javacalcapp
RUN yum install -y java java-devel
RUN javac /root/javacalcapp/Calc.java
ENTRYPOINT ["java", "Calc"]