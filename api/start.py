from config import *
from models import *
from routes import *

with app.app_context():
    @app.route("/")
    def inicio():
        return 'start'

    app.run(debug=True, host="0.0.0.0")