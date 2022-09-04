import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFFF3FFF7),
        secondaryHeaderColor: const Color(0xFF42E8C0),
      ),
      home: const MyHomePage(title: 'Calcolatore BMI'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //Variabili che salvano l'inserimento dell'utente
  String peso = '';
  String altezza = '';

  //Variabili che salvano il valore numerico inserito dall'utente (se valido)
  double _valPeso = 0;
  double _valAltezza = 0;
  double _valSliderPeso = 50;
  double _valSliderAltezza = 150;

  //Salvataggio del valore BMI
  double _bmi = 0;

  //Salvataggio esito (zona di appartenenza dell'utente)
  String _zonaBMI = '';

  //Variabili per 'Conditional visibility'
  bool _sliderVisibile = false;

  //Variabili che verificano se gli input sono validi
  bool _pesoValido = true;
  bool _altezzaValida = true;

  //Controller di testo
  TextEditingController controllerPeso = TextEditingController();
  TextEditingController controllerAltezza = TextEditingController();

  //FUNZIONI

  //Funzione che esegue il calcolo
  double _calcoloBMI(double statura, double peso) {

    double result = 0;
    statura /= 100; //Conversione da cm a m
    result = peso / (statura*statura);

    return double.parse((result).toStringAsFixed(2)); //Risultato restituito con solo 2 decimali dopo la virgola
  }

  //Funzione che restituisce la zona di appartenenza (a seconda del valore del BMI)
  String _esitoFinale(_valBMI) {

    if(_valBMI < 16.5) {
      return 'Sottopeso severo';
    }

    if(_valBMI >=16.5 && _valBMI <= 18.4) {
      return 'Sottopeso';
    }

    if(_valBMI >= 18.5 && _valBMI <= 24.9) {
      return 'Normale';
    }

    if(_valBMI >= 25 && _valBMI <= 30) {
      return 'Sovrappeso';
    }

    if(_valBMI >= 30.1 && _valBMI <= 34.9) {
      return 'in Obesità di I grado';
    }

    if(_valBMI >= 35 && _valBMI <= 40) {
      return 'in Obesità di II grado';
    }
      return 'in Obesità di III grado';

  }

  //Esito che ripulisce l'input
  void _clearInput() {

    if(!_sliderVisibile) {
      //Vengono ripuliti i 'TextField'
      controllerPeso.clear();
      controllerAltezza.clear();

      //Il valore di 'peso' e 'altezza' vengono resettati
      setState(() => _valPeso = 0);
      setState(() => _valAltezza = 0);
    }

  }

  void _switchSlider() {

    if(_sliderVisibile) {
      setState(() => _sliderVisibile = false);
      setState(() => _valPeso = 0);
      setState(() => _valAltezza = 0);

    }

    else {

      setState(() => _sliderVisibile = true);
      setState(() => _valPeso = _valSliderPeso);
      setState(() => _valAltezza = _valSliderAltezza);

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFFF3FFF7),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0,0,10.0,0),
            child: IconButton( //TextField <=> Slider
              icon: const Icon(Icons.change_circle),
              color: Colors.black,
              onPressed: () {
                _switchSlider();
              },
              tooltip: 'Cambio modalità di input',
            ),
          ),
          IconButton( //Ripulisci input
            icon: const Icon(Icons.remove_circle),
            color: Colors.black,
            onPressed: () {
              _clearInput();
            },
            tooltip: 'Ripulisci input',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            //Testo 'Peso'
            const Text('Massa [Kg]',
              style: TextStyle(fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 25,
              ),
            ),

            //Input 'Peso'
            //Modalità 'Slider'
            Visibility(
              visible: _sliderVisibile,
              child: Slider (
                value: _valSliderPeso,
                max: 200.0,
                divisions: 200,
                label: '${_valSliderPeso.round()}',
                onChanged: (double value) {
                  setState(() => _valSliderPeso = value);
                  setState(() => _valPeso = value);
                },
              ),
            ),

            //Modalità scrittura
            Visibility(
              visible: !_sliderVisibile,
              child: Container(
                margin: const EdgeInsets.all(20),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: controllerPeso,
                  decoration:InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Inserisci il tuo peso',
                    errorText: _pesoValido ? null: 'Inserire un valore valido',
                  ),
                  onChanged: (text) { //Variazione del TextField
                    setState(() {

                      //Tentativo e verifica di conversione
                      double? valPeso = double.tryParse(text);

                      if(valPeso == null || valPeso <= 0) { //Conversione impossibile
                        setState(() => _pesoValido = false);
                      }

                      else { //Conversione avvenuta con successo
                        setState(() => _pesoValido = true);
                        setState(() => _valPeso = valPeso);
                      }
                    });
                  },
                ),
              ),
            ),
            //Testo 'Altezza'
            const Text('Altezza [cm]',
              style: TextStyle(fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 25,
              ),
            ),

            //Input 'Altezza'

            //Modalità 'Slider'
            Visibility(
              visible: _sliderVisibile,
              child: Slider (
                value: _valSliderAltezza,
                max: 250.0,
                divisions: 250,
                label: '${_valSliderAltezza.round()}',
                onChanged: (double value) {
                  setState(() => _valSliderAltezza = value);
                  setState(() => _valAltezza = value);
                },
              ),
            ),

            Visibility(
              visible: !_sliderVisibile,
              child: Container(
                margin: const EdgeInsets.all(20),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: controllerAltezza,
                  decoration:InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Inserisci la tua altezza',
                    errorText: _altezzaValida ? null: 'Inserire un valore valido',
                  ),
                  onChanged: (text) { //Variazione del TextField
                    setState(() {

                      //Tentativo e verifica di conversione
                      double? valAltezza = double.tryParse(text);

                      if(valAltezza == null || valAltezza <= 0) { //Conversione impossibile
                        setState(() => _altezzaValida = false);
                      }

                      else { //Conversione avvenuta con successo
                        setState(() => _altezzaValida = true);
                        setState(() => _valAltezza = valAltezza);
                      }
                    });
                  },
                ),
              ),
            ),

             //Bottone che esegue il calcolo e restituisce il risultato
             SizedBox(
              width: 85,
              height: 85,
              child: ButtonTheme(
                minWidth: 80,
                height: 80,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0),),),
                  onPressed: () {

                    if((_pesoValido && _altezzaValida) && (_valPeso != 0 || _valAltezza != 0)) {
                      _bmi = _calcoloBMI(_valAltezza, _valPeso);
                      _zonaBMI = _esitoFinale(_bmi);
                      showDialog <String> (
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Risultato del tuo BMI'),
                          content: Text('Peso: $_valPeso Kg\nAltezza: $_valAltezza cm\nBMI: $_bmi\nSei $_zonaBMI'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Fine'),
                              child: const Text('Fine', style: TextStyle(color: Colors.black),),
                            )
                          ],
                        ),
                      );
                    }

                    else {
                      showDialog <String> (
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('ERRORE'),
                          content: const Text('Impossibile calcolare il BMI. Ricontrollare i dati inseriti'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Ok'),
                              child: const Text('Fine', style: TextStyle(color: Colors.black),),
                            )
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text ('BMI'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
