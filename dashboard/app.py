# Run this app with `python app.py` and
# visit http://127.0.0.1:8050/ in your web browser.

from dash import Dash, html, dcc
import plotly.express as px
import pandas as pd
from sqlalchemy import create_engine

conn_string = 'postgresql+psycopg2://kamila@localhost/postgres'
db = create_engine(conn_string)
conn = db.connect()



# assume you have a "long-form" data frame
# see https://plotly.com/python/px-arguments/ for more options
dfMock = pd.DataFrame({
    "datetime": ["yesterday", "today", "tomorrow"],
    "observation": [4, 1, 2],
})

def serve_layout():
    df = pd.read_sql("select * from test", conn);
    fig = px.line(df, x="datetime", y="observation")

    return html.Div(children=[
        html.H1(children='Hello Dash'),

        html.Div(children='''
        Dash: A web application framework for your data.
    '''),

    dcc.Graph(
        id='example-graph',
        figure=fig
    )
    ])

app = Dash(__name__)
app.layout = serve_layout

if __name__ == '__main__':
    app.run_server(debug=True)
