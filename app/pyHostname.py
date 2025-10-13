import os
import socket
from flask import Flask
from flask_mongoengine import MongoEngine

app = Flask(__name__)

# --- Configuração do Banco de Dados MongoDB local docker ---
#mongo_host = os.environ.get('MONGO_HOST', 'localhost')
#mongo_db_name = os.environ.get('MONGO_DB_NAME', 'pyhostname_db')

#app.config['MONGODB_SETTINGS'] = {
#    'db': mongo_db_name,
#    'host': mongo_host,
#    'port': 27017
#}


mongo_uri = os.environ.get('MONGO_URI')

app.config['MONGODB_SETTINGS'] = {
    'host': mongo_uri, 
}

db = MongoEngine(app)

# --- Modelo do Banco de Dados ---
class Counter(db.Document):
    id = db.StringField(primary_key=True, default='visitor_count') 
    count = db.IntField(default=0)


@app.route('/')
def hello():
    """Rota principal que exibe as informações e atualiza o contador."""
    hostname = socket.gethostname()
    
    try:
        counter_obj = Counter.objects(id='visitor_count').modify(
            upsert=True, 
            inc__count=1, 
            new=True
        )
        visitor_count = counter_obj.count

    except Exception as e:
        print(f"Erro ao acessar o MongoDB: {e}")
        visitor_count = "Erro no Banco de Dados"

    return f"""
    <html>
        <head>
            <title>Pyhostname</title>
            <style>
                body {{ font-family: sans-serif; text-align: center; margin-top: 50px; background-color: #000; color: white; }}
                h1 {{ color: #fff; }}
                p {{ font-size: 1.2em; }}
            </style>
        </head>
        <body>
            <h1>Opa,eai? Bem-vindo ao Projeto Pyhostname!</h1>
            
            <p>Esta pagina está rodandando no conteiner com hostname: <span style='background-color: white; color: black; padding: 2px 6px; border-radius: 1px;'><strong>{hostname}</strong></span></p>
            <p>Numero de visitantes: <span style='background-color: white; color: black; padding: 2px 6px; border-radius: 1px;'><strong>{visitor_count}</strong></span></p>
        </body>
    </html>
    """

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)