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


app.get('/topics_count', cors(), function (req, res) {
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

app.get('/topics_projects', cors(), function (req, res) {
	query = "select * from projects_topics_view";

	topic = req.query.topic;
	console.log('topic: ' + topic);
	if (topic != undefined) {
		query += " where topic = '" + topic + "'";
	}

	query += " order by topic, name";

	console.log('query: ' + query);
	pool.query(query, function (err, rows, fields) {
	  if (err) throw err

	  res.type('json');
	  res.end(JSON.stringify(rows));
	})
})


app.get('/taxonomy', cors(), function (req, res) {
	query = "select category, subcategory, display_name, id, synonym"
		  + " from taxonomy_tags_synonyms";

	category = req.query.category;
	if (category != undefined) {
		query += " where category = '" + category + "'";
	}

	query += " order by category, subcategory, display_name, synonym";

	console.log('query: ' + query);
	pool.query(query, function (err, rows, fields) {
	  if (err) throw err

	  var cat = "";
	  var subcat = "";
	  var subcateg = null;
	  var categories = new Array();
	  var c = 0;
	  var item_name = "";
	  for(var row of rows) {
		  //console.log("Row: " + row.display_name + " " + row.category + " " + row.subcategory);
		  if(cat != row.category) {
			  subcat = "";
			  subcateg = null;
			  cat = row.category;
			  //console.log("New category: " + cat);
			  categ = { text: cat, children: [] };
			  categories[c] = categ;
			  c = c+1;
			  item_name = "";
		  }
		  if(row.subcategory != null && subcat != row.subcategory) {
			  subcat = row.subcategory;
			  //console.log("New subcategory: " + subcat);
			  subcateg = { text: subcat, children: [] };
			  categ.children.push(subcateg);
			  item_name = "";
		  }
		  if(item_name != row.display_name) {
			item_name = row.display_name;
			item = {text: row.display_name, id:row.id};
			if(row.synonym != null) {
				item.children = new Array();
				item.children.push(row.synonym);
			}
			if(subcateg != null) {
				subcateg.children.push(item);
			} else {
				categ.children.push(item);
			}
		  } else { // same item so should be synonyms
		    if(item.children) {
			  item.children.push(row.synonym);
			}
		  }
	  }
	  //console.log(JSON.stringify(categories));

	  taxonomy = new Object();
	  taxonomy.categories = categories;

	  res.type('json');
	  //res.end(JSON.stringify(taxonomy));
	  res.end(JSON.stringify(categories));
	})
})

app.get('/categories', cors(), function (req, res) {
	query = "select category, count(*) as number_of_items from taxonomy_tags"
		  + " group by category order by category";

	console.log('query: ' + query);
	pool.query(query, function (err, rows, fields) {
	  if (err) throw err

	  res.type('json');
	  res.end(JSON.stringify(rows));
	})
})


app.get('/not_assigned_topics', cors(), function (req, res) {
	query = "select * from not_assigned_synonyms"
		  + " order by name, topic";

	console.log('query: ' + query);
	pool.query(query, function (err, rows, fields) {
	  if (err) throw err

	  var proj = "";
	  var projects = new Array();
	  for(var row of rows) {
		  //console.log("Project: " + proj);
		  //console.log("Row: " + row.name);
		  if(proj != row.name) {
			proj = ""+row.name;
			project = {name: row.name, description: row.description, code_url: row.code_url, topics: new Array()};
			projects.push(project);
		  }
		  project.topics.push(row.topic);
	  }
	  res.type('json');
	  res.end(JSON.stringify(projects));
	})
})


app.get('/not_assigned_topics2', cors(), function (req, res) {
	query = "select * from not_assigned_synonyms"
		  + " order by topic, name";

	console.log('query: ' + query);
	pool.query(query, function (err, rows, fields) {
	  if (err) throw err

	  var t = "";
	  var topics = new Array();
	  var p = 0;
	  for(var row of rows) {
		  //console.log("Project: " + proj);
		  //console.log("Row: " + row.name);
		  if(t != row.topic) {
			t = ""+row.topic;
			p = 0;
			topic = {text: row.topic, num_of_projects: p, children: new Array()};
			topics.push(topic);
		    //topic.num_of_projects = p;
		  }
		  // if doesn't exist in topic.projects {
		  p = p+1;
		  topic.num_of_projects = p;
		  project = {project_id: row.project_id, text: row.name, description: row.description, code_url: row.code_url};
		  topic.children.push(project);
	  }
	  res.type('json');
	  res.end(JSON.stringify(topics));
	})
})

app.get('/organizations_projects', cors(), function (req, res) {
	query = "select * from organizations_projects_count order by name"
		  + " order by name";

	console.log('query: ' + query);
	pool.query(query, function (err, rows, fields) {
	  if (err) throw err

	  res.type('json');
	  res.end(JSON.stringify(rows));
	})
})


app.get('/search_taxonomy', cors(), function (req, res) {
	query = "select distinct synonym as tag, display_name as issue, tag_id as issue_id";
	query += " from taxonomy_tags_synonyms";
	
	search = req.query.search;
	if(!search || search.length < 3) {
		console.log("search empty: " + search);
		throw new Error("Search term of at least 3 characters is mandatory");
	}
	
	query += " where synonym like '%"+search+"%'";
	query += " order by synonym, display_name";

	console.log('query: ' + query);
	pool.query(query, function (err, rows, fields) {
	  if (err) throw err

	  res.type('json');
	  res.end(JSON.stringify(rows));
	})
})

app.get('/search_tags', cors(), function (req, res) {
	query = "select topic as tag, name as project_name, code_url from not_assigned_synonyms";
	
	search = req.query.search;
	if(!search || search.length < 3) {
		console.log("search empty: " + search);
		throw new Error("Search term of at least 3 characters  is mandatory");
	}
	
	query += " where topic like '%"+search+"%'";
	query += " order by topic, name";

	console.log('query: ' + query);
	pool.query(query, function (err, rows, fields) {
	  if (err) throw err

	  var t = "";
	  var tags = new Array();
	  var p = 0;
	  for(var row of rows) {
		  if(t != row.tag) {
			t = ""+row.tag;
			p = 0;
			tag = {tag: row.tag, num_of_projects: p, projects: new Array()};
			tags.push(tag);
		  }
		  p = p+1;
		  tag.num_of_projects = p;
		  project = {name: row.project_name, code_url: row.code_url};
		  tag.projects.push(project);
	  }
	  
	  res.type('json');
	  res.end(JSON.stringify(tags));
	})
})


var server = app.listen(PORT, function () {
   var host = server.address().address
   var port = server.address().port
   //connection.connect()
   console.log("App listening at http://%s:%s", host, port)
})


app.use(cors())


// when shutdown signal is received, do graceful shutdown
process.on('SIGINT', function () {
	server.close( function () {
		pool.end(function (err) {
			console.log( 'gracefully shutting down :)' );
			process.exit();
		});
	});
});
