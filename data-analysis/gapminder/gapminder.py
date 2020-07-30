import pandas as pd
from bokeh.models import (LinearInterpolator,
                          CategoricalColorMapper,
                          ColumnDataSource,
                          HoverTool,
                          NumeralTickFormatter,
                          Slider)

from bokeh.layouts import column
from bokeh.palettes import Spectral5
from bokeh.io import show, curdoc
from bokeh.plotting import figure, output_file, save

data = pd.read_csv('../../data/gapminder/gapminder.tsv', sep='\t', index_col = 'year')

source = ColumnDataSource(data.loc[data.index.min()])
PLOT_OPTS = dict(
    height=400, width = 800, x_axis_type='log',
    x_range = (100,100000), y_range = (0,100),
    background_fill_color = 'black'
)

# Making Hover
hover = HoverTool(tooltips = '@country', show_arrow = False)
fig = figure(tools = [hover],
             toolbar_location = 'above',
             **PLOT_OPTS)

# Mapping biggest population to size 50
# Linearly interpolating all of the one in between
size_mapper = LinearInterpolator(
    x = [data['pop'].min(), data['pop'].max()],
    y = [10,60]
)

color_mapper = CategoricalColorMapper(
    factors = data.continent.unique().tolist(),
    palette = Spectral5,
)



fig.circle('gdpPercap', 'lifeExp',
           size = {'field':'pop', 'transform':size_mapper},
           color = {'field': 'continent', 'transform': color_mapper},
           alpha = 0.6,
           legend_field = 'continent',
           source = source,
           hover_color='white',
           line_color="white"
           )

# Move Legends off Canvas
fig.legend.border_line_color = None
fig.legend.location = (0,200)
fig.right.append(fig.legend[0])
fig.axis[0].formatter = NumeralTickFormatter(format = "$0")


def update(attr, old, new):
    year = new
    new_data = data.loc[year]
    source.data = new_data
    fig.title.text = str(year)


slider = Slider(start = data.index.min(), end = data.index.max(), step = 1, title = 'Year')
slider.on_change('value', update)

layout = column(fig, slider)
curdoc().add_root(layout)
output_file("slider.html", title="slider.py example")
save(fig)
