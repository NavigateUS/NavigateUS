Map<String, List<Map<String, String>>> graph = {
  "Kent Ridge Bus Terminal": [
    {
      "bus": "A1",
      "nextBusStop": "LT 13",
    },
    {
      "bus": "A2",
      "nextBusStop": "Information Technology",
    },
  ],
  "Information Technology": [
    {
      "bus": "A2",
      "nextBusStop": "Opp Yusof Ishak House",
    },
    {
      "bus": "D1",
      "nextBusStop": "Opp Yusof Ishak House",
    },
    {
      "bus": "E",
      "nextBusStop": "Opp Yusof Ishak House",
    },
  ],
  "Opp Yusof Ishak House": [
    {
      "bus": "A2",
      "nextBusStop": "Museum",
    },
    {
      "bus": "D1",
      "nextBusStop": "Museum",
    },
    {
      "bus": "E",
      "nextBusStop": "University Town",
    },
  ],
  "Museum": [
    {
      "bus": "A2",
      "nextBusStop": "University Health Centre",
    },
    {
      "bus": "D1",
      "nextBusStop": "University Town",
    },
    {
      "bus": "D2",
      "nextBusStop": "University Town",
    },
    {
      "bus": "BTC",
      "nextBusStop": "Yusof Ishak House",
    },
    {
      "bus": "K",
      "nextBusStop": "University Health Centre",
    },
  ],
  "University Health Centre": [
    {
      "bus": "A2",
      "nextBusStop": "Opp University Hall",
    },
    {
      "bus": "D2",
      "nextBusStop": "Opp University Hall",
    },
    {
      "bus": "K",
      "nextBusStop": "Opp University Hall",
    },
  ],
  "Opp University Hall": [
    {
      "bus": "A2",
      "nextBusStop": "S 17",
    },
    {
      "bus": "D2",
      "nextBusStop": "S 17",
    },
    {
      "bus": "K",
      "nextBusStop": "S 17",
    },
  ],
  "S 17": [
    {
      "bus": "A2",
      "nextBusStop": "Opp Kent Ridge MRT",
    },
    {"bus": "D2", "nextBusStop": "Opp Kent Ridge MRT"},
    {
      "bus": "K",
      "nextBusStop": "Opp Kent Ridge MRT",
    },
  ],
  "Opp Kent Ridge MRT": [
    {
      "bus": "A2",
      "nextBusStop": "Prince George's Park Residences",
    },
    {
      "bus": "D2",
      "nextBusStop": "Prince George's Park Residences",
    },
    {
      "bus": "K",
      "nextBusStop": "Prince George's Park Residences",
    },
  ],
  "Prince George's Park Residences": [
    {
      "bus": "A2",
      "nextBusStop": "TCOMS",
    },
    {"bus": "D2", "nextBusStop": null},
    {
      "bus": "K",
      "nextBusStop": null,
    },
  ],
  "TCOMS": [
    {
      "bus": "A2",
      "nextBusStop": "Opp Hon Sui Sen Memorial Library",
    },
  ],
  "Opp Hon Sui Sen Memorial Library": [
    {
      "bus": "A2",
      "nextBusStop": "Opp NUSS",
    },
    {
      "bus": "D1",
      "nextBusStop": "Opp NUSS",
    },
  ],
  "Opp NUSS": [
    {
      "bus": "A2",
      "nextBusStop": "COM 2",
    },
    {
      "bus": "D1",
      "nextBusStop": "COM 2",
    },
  ],
  "COM 2": [
    {
      "bus": "A1",
      "nextBusStop": "BIZ 2",
    },
    {
      "bus": "A2",
      "nextBusStop": "Ventus",
    },
    {
      "bus": "D1",
      "nextBusStop": "Ventus",
    },
    {
      "bus": "D1",
      "nextBusStop": "BIZ 2",
    },
  ],
  "Ventus": [
    {
      "bus": "A2",
      "nextBusStop": "Kent Ridge Bus Terminal",
    },
    {
      "bus": "D1",
      "nextBusStop": "Information Technology",
    },
  ],
  "University Town": [
    {
      "bus": "D1",
      "nextBusStop": "Yusof Ishak House",
    },
    {
      "bus": "D2",
      "nextBusStop": "University Health Centre",
    },
    {
      "bus": "BTC",
      "nextBusStop": "Raffles Hall",
    },
    {
      "bus": "E",
      "nextBusStop": "Raffles Hall",
    },
  ],
  "Yusof Ishak House": [
    {
      "bus": "D1",
      "nextBusStop": "Central Library",
    },
    {
      "bus": "BTC",
      "nextBusStop": "Central Library",
    },
    {
      "bus": "K",
      "nextBusStop": "Central Library",
    },
    {
      "bus": "A1",
      "nextBusStop": "Central Library",
    },
  ],
  "Central Library": [
    {
      "bus": "D1",
      "nextBusStop": "LT 13",
    },
    {
      "bus": "BTC",
      "nextBusStop": "LT 13",
    },
    {
      "bus": "K",
      "nextBusStop": "Opp SDE 3",
    },
    {
      "bus": "A1",
      "nextBusStop": "Kent Ridge Bus Terminal",
    },
  ],
  "LT 13": [
    {
      "bus": "D1",
      "nextBusStop": "AS 5",
    },
    {
      "bus": "BTC",
      "nextBusStop": "AS 5",
    },
    {
      "bus": "A1",
      "nextBusStop": "AS 5",
    },
  ],
  "AS 5": [
    {
      "bus": "D1",
      "nextBusStop": "COM 2",
    },
    {
      "bus": "BTC",
      "nextBusStop": "BIZ 2",
    },
    {
      "bus": "A1",
      "nextBusStop": "COM 2",
    },
  ],
  "BIZ 2": [
    {
      "bus": "D1",
      "nextBusStop": null,
    },
    {
      "bus": "BTC",
      "nextBusStop": "Prince George's Park",
    },
    {
      "bus": "A1",
      "nextBusStop": "Opp TCOMS",
    },
  ],
  "Prince George's Park": [
    {
      "bus": "D2",
      "nextBusStop": "Kent Ridge MRT",
    },
    {
      "bus": "BTC",
      "nextBusStop": "College Green",
    },
    {
      "bus": "K",
      "nextBusStop": "Kent Ridge MRT",
    },
    {
      "bus": "A1",
      "nextBusStop": "Kent Ridge MRT",
    },
  ],
  "Kent Ridge MRT": [
    {
      "bus": "D2",
      "nextBusStop": "LT 27",
    },
    {
      "bus": "BTC",
      "nextBusStop": "LT 27",
    },
    {
      "bus": "K",
      "nextBusStop": "LT 27",
    },
    {
      "bus": "A1",
      "nextBusStop": "LT 27",
    },
  ],
  "LT 27": [
    {
      "bus": "D2",
      "nextBusStop": "University Hall",
    },
    {
      "bus": "BTC",
      "nextBusStop": "University Hall",
    },
    {
      "bus": "K",
      "nextBusStop": "University Hall",
    },
    {
      "bus": "A1",
      "nextBusStop": "University Hall",
    },
  ],
  "University Hall": [
    {
      "bus": "D2",
      "nextBusStop": "Opp University Health Centre",
    },
    {
      "bus": "BTC",
      "nextBusStop": "Opp University Health Centre",
    },
    {
      "bus": "K",
      "nextBusStop": "Opp University Health Centre",
    },
    {
      "bus": "A1",
      "nextBusStop": "Opp University Health Centre",
    },
  ],
  "Opp University Health Centre": [
    {
      "bus": "D2",
      "nextBusStop": "Museum",
    },
    {
      "bus": "BTC",
      "nextBusStop": "University Town",
    },
    {
      "bus": "K",
      "nextBusStop": "Yusof Ishak House",
    },
    {
      "bus": "A1",
      "nextBusStop": "Yusof Ishak House",
    },
  ],
  "Oei Tiong Ham Building": [
    {
      "bus": "BTC",
      "nextBusStop": "Botanic Gardens MRT",
    },
    {
      "bus": "L",
      "nextBusStop": "Botanic Gardens MRT",
    },
  ],
  "Botanic Gardens MRT": [
    {
      "bus": "BTC",
      "nextBusStop": "Kent Ridge MRT",
    },
    {
      "bus": "L",
      "nextBusStop": "College Green",
    },
  ],
  "Raffles Hall": [
    {
      "bus": "BTC",
      "nextBusStop": "Kent Vale",
    },
    {
      "bus": "E",
      "nextBusStop": "Kent Vale",
    },
  ],
  "Kent Vale": [
    {
      "bus": "BTC",
      "nextBusStop": "Museum",
    },
    {
      "bus": "E",
      "nextBusStop": "EA",
    },
    {
      "bus": "K",
      "nextBusStop": "Museum",
    },
  ],
  "College Green": [
    {
      "bus": "BTC",
      "nextBusStop": "Oei Tiong Ham Building",
    },
    {
      "bus": "L",
      "nextBusStop": "Oei Tiong Ham Building",
    },
  ],
  "EA": [
    {
      "bus": "E",
      "nextBusStop": "SDE 3",
    },
  ],
  "SDE 3": [
    {
      "bus": "E",
      "nextBusStop": "Information Technology",
    },
  ],
  "Opp SDE 3": [
    {
      "bus": "K",
      "nextBusStop": "The Japanese Primary School",
    },
  ],
  "The Japanese Primary School": [
    {
      "bus": "K",
      "nextBusStop": "Kent Vale",
    },
  ],
  "Opp TCOMS": [
    {
      "bus": "A1",
      "nextBusStop": "Prince George's Park",
    },
  ],
};
