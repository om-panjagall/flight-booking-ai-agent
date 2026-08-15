import 'package:flutter/material.dart';

import '../../../airports/domain/entities/airports.dart';

class SearchCard extends StatefulWidget {
  final List<Airport> airports;
  final bool loadingAirports;

  final void Function({
    required Airport source,
    required Airport destination,
    required DateTime date,
    required int adults,
  })? onSearch;

  const SearchCard({
    super.key,
    required this.airports,
    this.loadingAirports = false,
    this.onSearch,
  });

  @override
  State<SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  Airport? _source;
  Airport? _destination;

  DateTime? _departureDate;

  int _adults = 1;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black12,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _buildAirportSelector(
              label: 'From',
              hint: 'Departure airport',
              icon: Icons.flight_takeoff,
              value: _source,
              onChanged: (airport) {
                setState(() {
                  _source = airport;
                });
              },
            ),

            const SizedBox(height: 15),

            _buildAirportSelector(
              label: 'To',
              hint: 'Arrival airport',
              icon: Icons.flight_land,
              value: _destination,
              onChanged: (airport) {
                setState(() {
                  _destination = airport;
                });
              },
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: _buildDateSelector(context),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildPassengerSelector(),
                ),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.search),
                onPressed: _handleSearch,
                label: const Text(
                  'Search Flights',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAirportSelector({
    required String label,
    required String hint,
    required IconData icon,
    required Airport? value,
    required ValueChanged<Airport?> onChanged,
  }) {
    return DropdownButtonFormField<Airport>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: widget.airports.map((airport) {
        return DropdownMenuItem<Airport>(
          value: airport,
          child: Text(
            '${airport.code} - ${airport.city}',
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: widget.loadingAirports ? null : onChanged,
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    final text = _departureDate == null
        ? 'Select date'
        : _formatDate(_departureDate!);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.calendar_today),
          labelText: 'Departure',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildPassengerSelector() {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: _selectPassengers,
      child: InputDecorator(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.people),
          labelText: 'Passengers',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          '$_adults Adult${_adults == 1 ? '' : 's'}',
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(
        const Duration(days: 1),
      ),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );

    if (selected == null) {
      return;
    }

    setState(() {
      _departureDate = selected;
    });
  }

  Future<void> _selectPassengers() async {
    final selected = await showDialog<int>(
      context: context,
      builder: (context) {
        int value = _adults;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Passengers'),
              content: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: value > 1
                        ? () {
                            setDialogState(() {
                              value--;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.remove),
                  ),

                  Text(
                    '$value',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  IconButton(
                    onPressed: value < 9
                        ? () {
                            setDialogState(() {
                              value++;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, value);
                  },
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );

    if (selected != null) {
      setState(() {
        _adults = selected;
      });
    }
  }

  void _handleSearch() {
    if (_source == null) {
      _showError('Please select departure airport');
      return;
    }

    if (_destination == null) {
      _showError('Please select arrival airport');
      return;
    }

    if (_source!.code == _destination!.code) {
      _showError(
        'Departure and arrival airports cannot be the same',
      );
      return;
    }

    if (_departureDate == null) {
      _showError('Please select departure date');
      return;
    }

    widget.onSearch?.call(
      source: _source!,
      destination: _destination!,
      date: _departureDate!,
      adults: _adults,
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}