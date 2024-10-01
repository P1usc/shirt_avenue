import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shirt_avenue/models/prodotto.dart';
import 'package:shirt_avenue/services/cerca_service.dart';
import 'package:shirt_avenue/widgets/prodotto_card_widget.dart';

class CercaPage extends StatefulWidget {
  const CercaPage({super.key});

  @override
  _CercaPageState createState() => _CercaPageState();
}

class _CercaPageState extends State<CercaPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Prodotto> _prodotti = [];
  bool _isLoading = false;
  String? _errorMessage; // Add a variable to hold error messages
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.length >= 3) {
        _searchProdotti();
      } else {
        setState(() {
          _prodotti = []; // Clear products if less than 3 letters
          _errorMessage = null; // Reset error message
        });
      }
    });
  }

  void _searchProdotti() async {
    String searchTerm = _searchController.text.trim();
    if (searchTerm.isNotEmpty) {
      setState(() {
        _isLoading = true;
        _errorMessage = null; // Reset error message on new search
      });

      try {
        final prodotti =
            await RicercaProdottoService().cercaProdotti(searchTerm);
        setState(() {
          _prodotti = prodotti;
        });
      } catch (e) {
        print('Errore durante la ricerca dei prodotti: $e');
        setState(() {
          _errorMessage = 'Si è verificato un errore durante la ricerca.';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cerca prodotto',
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _prodotti = [];
                            _errorMessage = null; // Clear error message
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                _onSearchChanged();
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null // Check for error message
                      ? Center(child: Text(_errorMessage!))
                      : _prodotti.isNotEmpty
                          ? GridView.builder(
                              padding: const EdgeInsets.all(8.0),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.7,
                              ),
                              itemCount: _prodotti.length,
                              itemBuilder: (context, index) {
                                final prodotto = _prodotti[index];
                                return ProdottoCard(prodotto: prodotto);
                              },
                            )
                          : const Center(
                              child: Text('Nessun prodotto trovato')),
            ),
          ],
        ),
      ),
    );
  }
}
