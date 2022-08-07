FROM python:3.10-slim

WORKDIR /app

# 设置时区
RUN rm -rf /etc/localtime && \
  ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 设置源并更新
RUN sed -i "s/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list && \
  rm -rf /var/lib/apt/lists/* && \
  apt-get update  

# 安装ffmpeg和定时插件
RUN apt-get install -y curl wget ffmpeg cron && \
    rm -rf /var/lib/apt/lists/*

# 设置pip源
RUN pip3 config set global.index-url https://pypi.douban.com/simple/
# 安装you-get
RUN pip3 install you-get
# 测试查看日志
RUN touch /var/log/cron.log

COPY --chmod=755 bili.sh DanmakuFactory /app/
COPY --chmod=755 cronfile /etc/cron.d/

CMD cron && tail -f /var/log/cron.log