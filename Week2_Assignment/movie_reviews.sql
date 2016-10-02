create schema if not exists movie_reviews;

use movie_reviews;

drop table if exists reviews, critics, films;

create table films (
	id smallint NOT NULL auto_increment,
    title varchar(200),
	release_year smallint,
	imdb_rating	decimal(3, 1),
    genre varchar(100),
	mpaa_rating	varchar(5),
    runtime smallint,
	imdb_votes mediumint,
	gross decimal(6, 2),
	director varchar(100),
    PRIMARY KEY (id)
);

create table critics (
	id smallint NOT NULL auto_increment PRIMARY KEY,
    initials varchar(2),
    gender varchar(1)
);

create table if not exists reviews (
    id smallint NOT NULL auto_increment PRIMARY KEY,
    film_id smallint,
    critic_id smallint,
    score tinyint,
    foreign key (film_id) references films(id),
	foreign key (critic_id) references critics(id)
);

insert into films 
(title, release_year, imdb_rating, genre, 
	mpaa_rating, runtime, imdb_votes, gross, director)
values 
('The Shawshank Redemption', 1994, 9.3, 'Crime/Drama',
	'R', 142, 1701593, 28.34, 'Darabont'),
('The Dark Knight',	2008, 8.9, 'Action/Crime/Drama',	
    'PG-13', 152, 1688932, 533.32, 'Nolan'),
('Pulp Fiction', 1994, 8.9,	'Crime/Drama',
	'R', 154, 1333651, 107.93, 'Tarantino'),
('Schindler''s List', 1993,	8.9, 'Biography/Drama/History',
	'R', 195, 871296, 96.07, 'Spielberg'),
('The Lord of the Rings: The Return of the King', 2003,	8.9, 'Action/Adventure/Drama',
	'PG-13', 201, 1223750, 377.02, 'Jackson'),
('Fight Club', 1999, 8.8, 'Drama', 
	'R', 139, 1357516, 37.02, 'Fincher'),
('Inception', 2010,	8.8, 'Action/Adventure/Sci-Fi',
	'PG-13', 148, 1479613, 292.57, 'Nolan'),
('The Lord of the Rings: The Fellowship of the Ring', 2001, 8.8, 'Action/Adventure/Drama',
	'PG-13', 178, 1246681, 313.84, 'Jackson'),
('Forest Gump', 1994, 8.8, 'Comedy/Drama',
	'PG-13', 142, 1261695, 329.69, 'Zemeckis'),
('The Matrix', 1999, 8.7, 'Action/Sci-Fi',
	'R', 136, 1226030, 171.38,	'Wachowskis');

insert into critics (initials, gender)
values 
('SA', 'm'),
('AA', 'f'),
('JA', 'm'),
('DL', 'f'),
('JA', 'm'),
('BT', 'm');


insert into reviews (film_id, critic_id, score)
values
(1, 1, 5),(2, 1, 3),(3, 1, 4),(4, 1, 5),(5, 1, 4),
(6, 1, 3),(7, 1, 3),(8, 1, 4),(9, 1, 5),(10, 1, 4),
(1, 2, 5),(2, 2, NULL),(3, 2, NULL),(4, 2, 5),(5, 2, 4),
(6, 2, NULL),(7, 2, NULL),(8, 2, 4),(9, 2, 5),(10, 2, NULL),
(1, 3, 5),(2, 3, 3),(3, 3, 4),(4, 3, 5),(5, 3, 3),
(6, 3, 4),(7, 3, 4),(8, 3, 4),(9, 3, 4),(10, 3, 5),
(1, 4, 4),(2, 4, 2),(3, 4, 4),(4, 4, 5),(5, 4, 3),
(6, 4, 4),(7, 4, 3),(8, 4, 5),(9, 4, 4),(10, 4, 3),
(1, 5, 5),(2, 5, 5),(3, 5, 5),(4, 5, 5),(5, 5, 3),
(6, 5, 5),(7, 5, 4),(8, 5, 4),(9, 5, 5),(10, 5, 5),
(1, 6, 5),(2, 6, 4),(3, 6, 5),(4, 6, 4),(5, 6, NULL),
(6, 6, 5),(7, 6, 5),(8, 6, NULL),(9, 6, 5),(10, 6, 4);

# result set query for csv output with headers 

select * 
into outfile '/Users/Shared/Data/movie_reviews.csv'
fields terminated by ',' optionally enclosed by '"'
escaped by '\\'
lines terminated by '\n'
from (select 'title', 'release_year', 'imdb_rating'
	, 'genre', 'mpaa_rating', 'gross', 'director'
    , 'critic', 'critic_gender', 'critic_score'
	union all
    (select flm.title, flm.release_year, flm.imdb_rating 
	, flm.genre, flm.mpaa_rating, flm.gross, flm.director
    , concat(crit.initials, rev.critic_id) as 'critic'
    , crit.gender
    , rev.score
	from films flm
	join reviews rev on flm.id = rev.film_id
	join critics crit on rev.critic_id = crit.id
	order by flm.title, critic
    )
) csvheaders;