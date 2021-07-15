var express = require('express');
var app = express();
var fs = require("fs");
var mysql = require('mysql')
var cors = require('cors')
var Q = require('q');

const bodyParser = require('body-parser');


require('dotenv').config();
// above gives an error in Heroku. To use .env locally run node -r dotenv/config your_script.js

const PORT = process.env.PORT || 8081;

const db_host = process.env.DB_HOST;
const db_user = process.env.DB_USER;
const db_pwd = process.env.DB_PWD;
const db_name = process.env.DB_DB;
console.log('Your database is %', db_name);
console.log('Your database server is %', db_host);

var ip = require("ip");
console.log(ip.address());

app.use(bodyParser.json());
app.use(bodyParser.urlencoded());  // for local testing

//connection.timeout = 0;

var pool = mysql.createPool({debug: true,
  connectionLimit : 10,
  host: db_host,
  user: db_user,
  password: db_pwd,
  database: db_name
})


app.get('/topic_count', function (req, res) {
	query = 'select * from projects_topics_count';
	
	topic = req.query.topic;
	console.log('topic: ' + topic);
	if (topic != undefined) {
		query += " where topic = '" + topic + "'";
	}
	
	query += " order by count desc";
	
	console.log('query: ' + query);
	
	pool.query(query, function (err, rows, fields) {
	  if (err) throw err

	  res.type('json');
	  res.end(JSON.stringify(rows));	  
	})
})

app.get('/topic_projects', function (req, res) {
	query = "select * from projects_topics_view";
	
	topic = req.query.topic;
	console.log('topic: ' + topic);
	if (topic != undefined) {
		query += " and topic = '" + topic + "'";
	}
	
	query += " order by topic, name";
	
	console.log('query: ' + query);
	pool.query(query, function (err, rows, fields) {
	  if (err) throw err

	  res.end(JSON.stringify(rows));	  
	})
})

app.get('/taxonomy', function (req, res) {
	query = "select category, display_name, id"
		  + " from taxonomy_tags";
	
	category = req.query.category;
	if (category != undefined) {
		query += " and category = '" + category + "'";
	}
	
	query += " order by category, display_name";
	
	console.log('query: ' + query);
	pool.query(query, function (err, rows, fields) {
	  if (err) throw err

	  res.end(JSON.stringify(rows));	  
	})
})

app.get('/categories', function (req, res) {
	query = "select category, count(*) as number_of_items from taxonomy_tags"
		  + " group by category order by category";
		
	console.log('query: ' + query);
	pool.query(query, function (err, rows, fields) {
	  if (err) throw err

	  res.end(JSON.stringify(rows));	  
	})
})

var server = app.listen(PORT, function () {
   var host = server.address().address
   var port = server.address().port
   //connection.connect()
   console.log("App listening at http://%s:%s", host, port)
})


app.use(cors())

//app.use('/doc', swaggerUi.serve, swaggerUi.setup(swaggerFile))

// when shutdown signal is received, do graceful shutdown
/*
process.on( 'SIGINT', function(){
  http_instance.close( function(){
    console.log( 'gracefully shutting down :)' );
	connection.end()
    process.exit();
  });
});
*/