const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const mysql = require('mysql2');

const app = express();
const port = 3000;

app.use(cors());
app.use(bodyParser.json());

// Configuration de la connexion à la base de données
const db = mysql.createConnection({
  host: '192.168.122.1',
  user: 'scott',
  password: 'oracle',
  database: 'Bibliotheque'
});

db.connect(err => {
  if (err) {
    console.error('Erreur de connexion à la base de données:', err);
    return;
  }
  console.log('Connecté à la base de données MySQL');
});

// Endpoint pour récupérer tous les livres
app.get('/api/livres', (req, res) => {
  const query = 'SELECT * FROM livres';
  db.query(query, (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(results);
  });
});

// Endpoint pour ajouter un nouveau livre
app.post('/api/livres', (req, res) => {
  const { titre, auteur, genre, disponibiliter } = req.body;
  const query = 'INSERT INTO livres (titre, auteur, genre, disponibiliter) VALUES (?, ?, ?, ?)';
  db.query(query, [titre, auteur, genre, disponibiliter], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json({ id: results.insertId });
  });
});

// Autres endpoints pour les autres tables...

app.listen(port, () => {
  console.log(`Serveur API REST démarré sur http://localhost:${port}`);
});
