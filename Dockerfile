FROM alpine:edge

# modprobe mousedev
# add packages
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk --update --no-cache add xrdp xvfb alpine-desktop xfce4 thunar-volman \
faenza-icon-theme paper-gtk-theme paper-icon-theme slim xf86-input-synaptics xf86-input-mouse xf86-input-keyboard \
setxkbmap openssh util-linux dbus wireshark ttf-freefont xauth supervisor x11vnc \
util-linux dbus ttf-freefont xauth xf86-input-keyboard sudo openjdk8-jre \
&& rm -rf /tmp/* /var/cache/apk/*

RUN apk --no-cache add git && git clone https://github.com/kanaka/noVNC.git /root/noVNC \
&& git clone https://github.com/kanaka/websockify /root/noVNC/utils/websockify \
&& rm -rf /root/noVNC/.git \
&& rm -rf /root/noVNC/utils/websockify/.git \
&& apk del git \
&& sed -i -- "s/ps -p/ps -o pid | grep/g" /root/noVNC/utils/launch.sh


# add scripts/config
ADD etc /etc
ADD docker-entrypoint.sh /bin

# prepare user aoj
RUN addgroup aoj \
&& adduser  -G aoj -s /bin/sh -D aoj \
&& echo "aoj:AoJHgTS" | /usr/sbin/chpasswd \
&& echo "aoj    ALL=(ALL) ALL" >> /etc/sudoers
ADD alpine /home/aoj
# RUN chown -R aoj:aoj /home/aoj; chmod -R u+rw /home/aoj; chmod +x /home/aoj/Desktop/*.desktop; chmod +x /home/aoj/JDownloader/JDownloader.sh
# prepare xrdp key
RUN xrdp-keygen xrdp auto





ENV LANG C.UTF-8
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk/jre
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin
ENV APP_USER aoj

RUN wget --quiet -O /home/aoj/JDownloader/JDownloader.jar http://installer.jdownloader.org/JDownloader.jar \
&& java -Djava.awt.headless=true -jar /home/aoj/JDownloader/JDownloader.jar > /dev/null 2>&1

RUN chown -R aoj:aoj /home/aoj; chmod -R u+rw /home/aoj; chmod +x /home/aoj/Desktop/*.desktop; chmod +x /home/aoj/JDownloader/JDownloader.sh

EXPOSE 3389
EXPOSE 8080
ENTRYPOINT ["/bin/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
