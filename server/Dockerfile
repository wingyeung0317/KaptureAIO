FROM python:3.12
RUN useradd -m kaptureaio
WORKDIR /app
COPY . .
RUN pip3 install -r requirements.txt
USER kaptureaio
EXPOSE 5000
CMD ["flask", "run"]

LABEL org.opencontainers.image.source=https://github.com/wingyeung0317/KaptureAIO
LABEL org.opencontainers.image.description="KaptureAIO Flask Server"
LABEL org.opencontainers.image.licenses=Apache