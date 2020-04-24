# COVID19 India

This repository scrapes [Ministry of Health and Family Welfare (Government of India)](https://www.mohfw.gov.in/) site to give you the latest official data of COVID19 Pandemic in India.

## Usage

1. Clone the repository

2. Install the required gems using:
   `$ bundle install`

3. Run the scraper using:
   `$ ruby data_generator`

### Files Generated

The web scraper daily scrapes the MoFHW site & creates the following files

- `data/{MM-DD-YYYY}_data.csv` file consisting daily data.
- `data/states_data_aggregated.csv` file consisting daily data appended, useful to draw times series graphs.


## Contributing

Please don't hesitate to make a PR if you have discovered any bugs or open an issue to request more features to this project.


## Authors

[Uday Kadaboina](http://uday.dev).

## License

This project is released under [MIT License](https://opensource.org/licenses/MIT).
