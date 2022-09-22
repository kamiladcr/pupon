# Run this app with `python app.py` and
# visit http://127.0.0.1:8050/ in your web browser.

from dash import Dash, html, dcc
import plotly.express as px
import pandas as pd
from sqlalchemy import create_engine

conn_string = 'postgresql+psycopg2://kamila@localhost/postgres'
db = create_engine(conn_string)
conn = db.connect()

def serve_layout():
    df_1 = pd.read_sql("select * from test", conn);
    df_2 = pd.read_sql("select * from observation_per_month", conn);

    raw_data = px.line(df_1, x="datetime", y="observation")
    bar_chart = px.bar(df_2, x='month', y='value', color='year', barmode='group')

    return html.Div(children=[
        html.H1(children='Hei'),

        html.Div(children='''
            My dash demo 
        '''),

        dcc.Graph(
            id='raw-data',
            figure=raw_data
        ),

        dcc.Graph(
            id='view-data',
            figure=bar_chart
        )
    ])

app = Dash(__name__)
app.layout = serve_layout 

if __name__ == '__main__':
    app.run_server(debug=True)

