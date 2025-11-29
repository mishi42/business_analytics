FROM python:3.12

RUN pip install --upgrade pip && \
    pip install mlflow

RUN mkdir ./mlflow  # 実験記録の保存フォルダ
