"""HTTP-сервис для проверки CI/CD."""
from flask import Flask, jsonify


def create_app():
    """Создаёт экземпляр Flask."""
    application = Flask(__name__)

    @application.get("/health")
    def health():
        return jsonify(status="ok")

    @application.get("/")
    def index():
        return jsonify(service="devops-ci-app", version="1.1.0-ramazanov", status="running")

    return application


app = create_app()
