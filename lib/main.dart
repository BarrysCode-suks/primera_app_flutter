import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(FitCasaApp());

class FitCasaApp extends StatefulWidget {
  @override
  _FitCasaAppState createState() => _FitCasaAppState();
}

class _FitCasaAppState extends State<FitCasaApp> {
  bool _modoOscuro = true;

  @override
  void initState() {
    super.initState();
    _cargarPreferencias();
  }

  _cargarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _modoOscuro = prefs.getBool('modoOscuro') ?? true;
    });
  }

  _cambiarModoOscuro(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _modoOscuro = value;
    });
    prefs.setBool('modoOscuro', value);
  }

  ThemeData _temaOscuro() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.redAccent,
      scaffoldBackgroundColor: Colors.black,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      cardTheme: CardTheme(color: Colors.grey[900]),
    );
  }

  ThemeData _temaClaro() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.red,
      scaffoldBackgroundColor: Colors.grey[100],
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.red,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      cardTheme: CardTheme(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitCasa Pro',
      debugShowCheckedModeBanner: false,
      theme: _modoOscuro ? _temaOscuro() : _temaClaro(),
      home: NavigationHandler(
        cambiarModoOscuro: _cambiarModoOscuro,
        modoOscuro: _modoOscuro,
      ),
    );
  }
}

class NavigationHandler extends StatefulWidget {
  final Function(bool) cambiarModoOscuro;
  final bool modoOscuro;

  NavigationHandler({required this.cambiarModoOscuro, required this.modoOscuro});

  @override
  State<NavigationHandler> createState() => _NavigationHandlerState();
}

class _NavigationHandlerState extends State<NavigationHandler> {
  int currentIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(),
      RoutineListScreen(),
      FavoritosScreen(),
      SettingsScreen(
        cambiarModoOscuro: widget.cambiarModoOscuro,
        modoOscuro: widget.modoOscuro,
      ),
      InfoScreen(),
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        backgroundColor: widget.modoOscuro ? Colors.black : Colors.white,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: widget.modoOscuro ? Colors.white54 : Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Rutinas'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Info'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<String> frasesMotivacionales = [
    "🔥 ¡Tu mejor proyecto eres tú mismo!",
    "💪 La disciplina es el puente entre tus metas y tus logros",
    "🚀 Hoy es un buen día para ser mejor que ayer",
    "🌟 El esfuerzo de hoy es el éxito de mañana",
    "🏆 No esperes inspiración, créala"
  ];

  @override
  Widget build(BuildContext context) {
    final fraseAleatoria = frasesMotivacionales[Random().nextInt(frasesMotivacionales.length)];
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: Text("🏋️ FitCasa Pro"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Frase motivacional
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[900] : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                fraseAleatoria,
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            
            // Rutina del día
            Card(
              color: isDarkMode ? Colors.grey[900] : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Rutina del Día",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Full Body - Nivel Intermedio",
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton.icon(
                      icon: Icon(Icons.flash_on),
                      label: Text("Comenzar Entrenamiento"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => RutinaScreen(rutinas[0])),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            
            // Accesos rápidos
            Text(
              "Explorar Categorías", 
              style: TextStyle(
                fontSize: 18,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                CategoryChip(icon: Icons.fitness_center, label: "Full Body", categoria: "Full Body"),
                CategoryChip(icon: Icons.accessibility, label: "Abdomen", categoria: "Abdomen"),
                CategoryChip(icon: Icons.accessibility, label: "Brazos", categoria: "Brazos y Hombros"),
                CategoryChip(icon: Icons.directions_run, label: "Piernas", categoria: "Glúteos y Piernas"),
                CategoryChip(icon: Icons.self_improvement, label: "Estiramientos", categoria: "Estiramientos"),
                CategoryChip(icon: Icons.healing, label: "Espalda", categoria: "Dolor de Espalda"),
                CategoryChip(icon: Icons.directions_run, label: "Cardio", categoria: "Cardio en Casa"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String categoria;
  
  const CategoryChip({required this.icon, required this.label, required this.categoria});
  
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return ActionChip(
      avatar: Icon(icon, color: Colors.redAccent),
      label: Text(label),
      backgroundColor: isDarkMode ? Colors.grey[850] : Colors.grey[300],
      labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RoutineListScreen(categoria: categoria),
          ),
        );
      },
    );
  }
}

class RoutineListScreen extends StatelessWidget {
  final String? categoria;
  
  RoutineListScreen({this.categoria});

  @override
  Widget build(BuildContext context) {
    final rutinasFiltradas = categoria == null 
        ? rutinas 
        : rutinas.where((r) => r.categoria == categoria).toList();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(categoria ?? "Todas las Rutinas"),
      ),
      body: ListView.builder(
        itemCount: rutinasFiltradas.length,
        itemBuilder: (context, index) {
          final rutina = rutinasFiltradas[index];
          return RoutineCard(rutina: rutina);
        },
      ),
    );
  }
}

class RoutineCard extends StatelessWidget {
  final Rutina rutina;
  
  const RoutineCard({required this.rutina});
  
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      margin: EdgeInsets.all(8),
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RutinaScreen(rutina)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.fitness_center, size: 40, color: Colors.redAccent),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rutina.nombre,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Nivel: ${rutina.nivel} • Tiempo: ${rutina.tiempo}",
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "${rutina.ejercicios.length} ejercicios",
                      style: TextStyle(
                        color: isDarkMode ? Colors.white54 : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios, 
                color: isDarkMode ? Colors.white54 : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RutinaScreen extends StatefulWidget {
  final Rutina rutina;
  RutinaScreen(this.rutina);

  @override
  _RutinaScreenState createState() => _RutinaScreenState();
}

class _RutinaScreenState extends State<RutinaScreen> {
  late SharedPreferences prefs;
  List<String> favoritos = [];
  bool sonidoActivado = true;
  bool isDarkMode = true;

  @override
  void initState() {
    super.initState();
    cargarPreferencias();
  }

  Future<void> cargarPreferencias() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      favoritos = prefs.getStringList('favoritos') ?? [];
      sonidoActivado = prefs.getBool('sonido') ?? true;
      isDarkMode = Theme.of(context).brightness == Brightness.dark;
    });
  }

  void toggleFavorito() {
    final id = widget.rutina.nombre;
    setState(() {
      if (favoritos.contains(id)) {
        favoritos.remove(id);
      } else {
        favoritos.add(id);
      }
      prefs.setStringList('favoritos', favoritos);
    });
  }

  bool esFavorito() => favoritos.contains(widget.rutina.nombre);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.rutina.nombre),
        actions: [
          IconButton(
            icon: Icon(esFavorito() ? Icons.favorite : Icons.favorite_border, 
                      color: Colors.redAccent),
            onPressed: toggleFavorito,
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: isDarkMode ? Colors.grey[900] : Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InfoItem(icon: Icons.timer, text: widget.rutina.tiempo),
                InfoItem(icon: Icons.bar_chart, text: widget.rutina.nivel),
                InfoItem(icon: Icons.fitness_center, text: "${widget.rutina.ejercicios.length} ejercicios"),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.rutina.ejercicios.length,
              itemBuilder: (context, index) {
                final ejercicio = widget.rutina.ejercicios[index];
                return ExerciseItem(ejercicio: ejercicio);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: Icon(Icons.play_arrow),
              label: Text("Iniciar Entrenamiento Guiado"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EntrenamientoScreen(widget.rutina)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  
  const InfoItem({required this.icon, required this.text});
  
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        Icon(icon, color: Colors.redAccent),
        SizedBox(height: 5),
        Text(
          text, 
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }
}

class ExerciseItem extends StatelessWidget {
  final Ejercicio ejercicio;
  
  const ExerciseItem({required this.ejercicio});
  
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      margin: EdgeInsets.all(8),
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(Icons.timer, color: Colors.redAccent),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ejercicio.nombre,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Duración: ${ejercicio.duracion} segundos",
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward,
              color: isDarkMode ? Colors.white54 : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class EntrenamientoScreen extends StatefulWidget {
  final Rutina rutina;
  EntrenamientoScreen(this.rutina);

  @override
  State<EntrenamientoScreen> createState() => _EntrenamientoScreenState();
}

class _EntrenamientoScreenState extends State<EntrenamientoScreen> {
  int index = 0;
  int tiempoRestante = 0;
  Timer? timer;
  bool estaPausado = false;
  bool sonidoActivado = true;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    cargarPreferencias();
  }

  Future<void> cargarPreferencias() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      sonidoActivado = prefs.getBool('sonido') ?? true;
    });
    iniciarEjercicio();
  }

  void iniciarEjercicio() {
    final ejercicio = widget.rutina.ejercicios[index];
    setState(() {
      tiempoRestante = ejercicio.duracion;
      estaPausado = false;
    });
    
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (!estaPausado) {
        if (tiempoRestante > 0) {
          setState(() => tiempoRestante--);
        } else {
          t.cancel();
          if (index < widget.rutina.ejercicios.length - 1) {
            setState(() => index++);
            iniciarEjercicio();
          } else {
            Navigator.pop(context);
          }
        }
      }
    });
  }

  void togglePausa() {
    setState(() => estaPausado = !estaPausado);
  }

  void reiniciarEjercicio() {
    setState(() => tiempoRestante = widget.rutina.ejercicios[index].duracion);
  }

  void saltarEjercicio() {
    if (index < widget.rutina.ejercicios.length - 1) {
      setState(() => index++);
      iniciarEjercicio();
    }
  }

  void ejercicioAnterior() {
    if (index > 0) {
      setState(() => index--);
      iniciarEjercicio();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ejercicio = widget.rutina.ejercicios[index];
    final progreso = 1 - (tiempoRestante / ejercicio.duracion);
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Entrenamiento Guiado"),
        actions: [
          IconButton(
            icon: Icon(sonidoActivado ? Icons.volume_up : Icons.volume_off),
            onPressed: () async {
              setState(() => sonidoActivado = !sonidoActivado);
              await prefs.setBool('sonido', sonidoActivado);
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  ejercicio.nombre,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        value: progreso,
                        strokeWidth: 10,
                        color: Colors.redAccent,
                        backgroundColor: Colors.grey[800],
                      ),
                    ),
                    Text(
                      "$tiempoRestante s",
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Ejercicio ${index + 1} de ${widget.rutina.ejercicios.length}",
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
              ],
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous, size: 30),
                  onPressed: ejercicioAnterior,
                  color: index > 0 ? Colors.white : Colors.grey,
                ),
                IconButton(
                  icon: Icon(estaPausado ? Icons.play_arrow : Icons.pause, size: 40),
                  onPressed: togglePausa,
                  color: Colors.redAccent,
                ),
                IconButton(
                  icon: Icon(Icons.replay, size: 30),
                  onPressed: reiniciarEjercicio,
                  color: Colors.white,
                ),
                IconButton(
                  icon: Icon(Icons.skip_next, size: 30),
                  onPressed: saltarEjercicio,
                  color: index < widget.rutina.ejercicios.length - 1 ? Colors.white : Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritosScreen extends StatefulWidget {
  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  List<String> favoritos = [];

  @override
  void initState() {
    super.initState();
    cargarFavoritos();
  }

  Future<void> cargarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoritos = prefs.getStringList('favoritos') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritas = rutinas.where((r) => favoritos.contains(r.nombre)).toList();
    
    return Scaffold(
      appBar: AppBar(title: Text("Rutinas Favoritas")),
      body: favoritas.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 60, color: Colors.grey),
                  SizedBox(height: 20),
                  Text("No tienes rutinas favoritas aún"),
                  SizedBox(height: 10),
                  Text("Agrega rutinas desde la lista de rutinas", 
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              itemCount: favoritas.length,
              itemBuilder: (context, index) {
                final r = favoritas[index];
                return RoutineCard(rutina: r);
              },
            ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  final Function(bool) cambiarModoOscuro;
  final bool modoOscuro;

  SettingsScreen({required this.cambiarModoOscuro, required this.modoOscuro});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool sonidoActivado = true;
  bool vibracionActivada = true;
  late bool modoOscuroActual; // Usaremos una copia local para manejar cambios

  @override
  void initState() {
    super.initState();
    modoOscuroActual = widget.modoOscuro;
    cargarPreferencias();
  }

  Future<void> cargarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      sonidoActivado = prefs.getBool('sonido') ?? true;
      vibracionActivada = prefs.getBool('vibracion') ?? true;
    });
  }

  void guardarPreferencia(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajustes")),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text("Preferencias de Entrenamiento", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SwitchListTile(
            title: Text("Sonido durante el ejercicio"),
            value: sonidoActivado,
            onChanged: (value) {
              setState(() => sonidoActivado = value);
              guardarPreferencia('sonido', value);
            },
          ),
          SwitchListTile(
            title: Text("Vibración durante el ejercicio"),
            value: vibracionActivada,
            onChanged: (value) {
              setState(() => vibracionActivada = value);
              guardarPreferencia('vibracion', value);
            },
          ),
          Divider(height: 30),
          Text("Apariencia", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SwitchListTile(
            title: Text("Modo Oscuro"),
            value: modoOscuroActual,
            onChanged: (value) {
              setState(() {
                modoOscuroActual = value;
              });
              widget.cambiarModoOscuro(value);
            },
          ),
        ],
      ),
    );
  }
}
class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Acerca de")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center, size: 80, color: Colors.redAccent),
            SizedBox(height: 20),
            Text(
              "FitCasa Pro",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Versión 2.0",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 30),
            Text(
              "FitCasa fue desarrollada para ayudarte a entrenar desde casa sin excusas. ¡Dale con todo!",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              "© 2025 Todos los derechos reservados",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class Ejercicio {
  final String nombre;
  final int duracion;
  Ejercicio(this.nombre, this.duracion);
}

class Rutina {
  final String nombre;
  final String nivel;
  final String tiempo;
  final String categoria;
  final List<Ejercicio> ejercicios;
  
  Rutina(this.nombre, this.nivel, this.tiempo, this.categoria, this.ejercicios);
}

final List<Rutina> rutinas = [
  Rutina("Full Body", "Intermedio", "15 min", "Full Body", [
    Ejercicio("Jumping Jacks", 40),
    Ejercicio("Sentadillas", 45),
    Ejercicio("Flexiones", 35),
    Ejercicio("Plancha", 50),
    Ejercicio("Burpees", 40),
  ]),
  Rutina("Abdomen", "Principiante", "10 min", "Abdomen", [
    Ejercicio("Crunches", 40),
    Ejercicio("Planchas laterales", 30),
    Ejercicio("Elevación de piernas", 35),
    Ejercicio("Bicicleta abdominal", 45),
  ]),
  Rutina("Brazos y Hombros", "Intermedio", "12 min", "Brazos y Hombros", [
    Ejercicio("Flexiones diamante", 35),
    Ejercicio("Fondos de tríceps", 40),
    Ejercicio("Flexiones inclinadas", 30),
    Ejercicio("Plancha con rotación", 45),
  ]),
  Rutina("Glúteos y Piernas", "Avanzado", "18 min", "Glúteos y Piernas", [
    Ejercicio("Sentadillas sumo", 40),
    Ejercicio("Zancadas", 45),
    Ejercicio("Elevación de cadera", 35),
    Ejercicio("Sentadillas búlgaras", 30),
    Ejercicio("Peso muerto a una pierna", 40),
  ]),
  Rutina("Estiramientos", "Principiante", "8 min", "Estiramientos", [
    Ejercicio("Estiramiento de espalda", 30),
    Ejercicio("Estiramiento de cuádriceps", 25),
    Ejercicio("Estiramiento de isquiotibiales", 35),
    Ejercicio("Estiramiento de hombros", 20),
  ]),
  Rutina("Dolor de Espalda", "Principiante", "10 min", "Dolor de Espalda", [
    Ejercicio("Gato-camello", 40),
    Ejercicio("Rotación de columna", 35),
    Ejercicio("Estiramiento de rodilla al pecho", 30),
    Ejercicio("Puente", 45),
  ]),
  Rutina("Cardio en Casa", "Avanzado", "20 min", "Cardio en Casa", [
    Ejercicio("High Knees", 45),
    Ejercicio("Mountain Climbers", 50),
    Ejercicio("Saltos de estrella", 40),
    Ejercicio("Escaladores", 45),
    Ejercicio("Saltos de tijera", 40),
  ]),
];