import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class AcoesDropdownCustom extends StatefulWidget {
  final List<String> opcoes;
  final String? valueSelected;
  final Function(String?) onChanged;
  final Function(String)? onToggleFavorite;
  final Function(String) isFavorite;

  const AcoesDropdownCustom({
    required this.opcoes,
    this.valueSelected,
    required this.onChanged,
    this.onToggleFavorite,
    required this.isFavorite,
    Key? key,
  }) : super(key: key);

  @override
  State<AcoesDropdownCustom> createState() => _AcoesDropdownCustomState();
}

class _AcoesDropdownCustomState extends State<AcoesDropdownCustom> {
  late List<String> _sortedOpcoes;

  @override
  void initState() {
    super.initState();
    _sortOpcoes();
  }

  void _sortOpcoes() {
    _sortedOpcoes = List<String>.from(widget.opcoes);
    _sortedOpcoes.sort((a, b) {
      bool aIsFav = widget.isFavorite(a);
      bool bIsFav = widget.isFavorite(b);
      if (aIsFav && !bIsFav) return -1;
      if (!aIsFav && bIsFav) return 1;
      return a.compareTo(b);
    });
  }

  @override
  void didUpdateWidget(AcoesDropdownCustom oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sortOpcoes();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        underline: SizedBox(),
        value: widget.valueSelected,
        hint: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Ação',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  letterSpacing: 0.0,
                ),
          ),
        ),
        onChanged: widget.onChanged,
        items: _sortedOpcoes
            .map<DropdownMenuItem<String>>((String value) {
              bool isFav = widget.isFavorite(value);
              return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          value,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                  ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.onToggleFavorite?.call(value);
                          setState(() {
                            _sortOpcoes();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            isFav ? Icons.star : Icons.star_outline,
                            color: isFav
                                ? Colors.amber
                                : FlutterFlowTheme.of(context).secondaryText,
                            size: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })
            .toList(),
      ),
    );
  }
}
