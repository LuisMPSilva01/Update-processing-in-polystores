CREATE TABLE countries (
    key SERIAL PRIMARY KEY,
    name VARCHAR(100),
    description TEXT
);

INSERT INTO countries (key, name, description) VALUES
    (1, 'Japan', 'Island nation known for its rich culture, technology, and cuisine.'),
    (2, 'China', 'The most populous country, renowned for its ancient civilization and rapid modernization.'),
    (3, 'Vietnam', 'Southeast Asian country with a diverse culture and breathtaking landscapes.'),
    (4, 'India', 'A diverse land of vibrant cultures, languages, and traditions, known for its spirituality and IT industry.'),
    (5, 'Brazil', 'South American giant famous for its Amazon rainforest, vibrant culture, and love for football.'),
    (6, 'Russia', 'The largest country, spanning two continents, known for its rich history, literature, and vast landscapes.'),
    (7, 'Germany', 'European powerhouse recognized for its engineering prowess, beer, and efficiency.'),
    (8, 'France', 'A country of art, fashion, and gastronomy, known for its iconic landmarks and romantic ambiance.'),
    (9, 'United States', 'A melting pot of cultures, innovation, and opportunity, with diverse landscapes and iconic cities.'),
    (10, 'South Korea', 'The tech-savvy nation famous for K-pop, kimchi, and rapid economic development.');

