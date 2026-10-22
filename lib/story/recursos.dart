import 'package:flutter/services.dart';

/// Sabe quais imagens existem na pasta assets (lido uma vez ao abrir o app).
/// Serve para não mostrar personagens que ainda não têm imagem.
class Recursos {
  Recursos._();

  static final Set<String> _assets = {};
  static bool _carregado = false;

  static Future<void> carregar() async {
    try {
      final manifesto = await AssetManifest.loadFromAssetBundle(rootBundle);
      _assets
        ..clear()
        ..addAll(manifesto.listAssets());
      _carregado = true;
    } catch (_) {
      _carregado = false; // se falhar, o app tenta carregar as imagens mesmo assim
    }
  }

  /// true se a lista de imagens foi lida com sucesso.
  static bool get carregadoComSucesso => _carregado;

  /// true se o arquivo existe (ou se não deu para conferir).
  static bool existe(String caminho) => !_carregado || _assets.contains(caminho);
}
