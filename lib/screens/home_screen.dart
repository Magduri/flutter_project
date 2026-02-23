import 'package:flutter/material.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Welcome Back!',
          style: TextStyle(color:Colors.white,
          fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF00796B),
          automaticallyImplyLeading: false,
          elevation: 0,
          actions: [
            IconButton(
             icon: const Icon(Icons.person_add_alt_1, color: Colors.white, size: 28),
            tooltip: 'Add New Patient',
            onPressed: () {},
            ),
            const SizedBox(width: 10),
          ],
          ),
          // 1. Material 3 SearchAnchor
          body: SafeArea(
        child: SingleChildScrollView(
          // This Padding ensures there is space on all sides, including the top!
          padding: const EdgeInsets.all(20.0), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchAnchor(
                viewBackgroundColor: const Color(0xFFF5F7FA),
                viewElevation: 0,
                builder: (BuildContext context, SearchController controller) {
                  return SearchBar(
                    controller: controller,
                    padding: const WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    onTap: () {
                      controller.openView();
                    },
                    leading: const Icon(Icons.search, color: Color(0xFF00796B)),
                    hintText: 'Search patient by name...',
                    hintStyle: WidgetStatePropertyAll<TextStyle>(
                      TextStyle(color: Colors.grey.shade500),
                    ),
                    backgroundColor: const WidgetStatePropertyAll<Color>(Colors.white),
                    elevation: const WidgetStatePropertyAll<double>(2.0),
                  );
                },
                suggestionsBuilder: (BuildContext context, SearchController controller) {
                  // Returning an empty list for now. 
                  // You will plug your web service API data in here later!
                  return []; 
                },
              ),
              
              // This creates the space between the Search bar and the Attention header
              const SizedBox(height: 35),

              // 2. Attention Needed Header
              Row(
                children: const [
                  Icon(Icons.warning_amber_rounded, color: Color(0xFFE53935), size: 28),
                  SizedBox(width: 8),
                  Text(
                    'Attention Needed',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE53935),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 15),

              // 3. Placeholder for the Critical Patient Card
              const Text("Critical patients!"),
            ],
          ),
        ),
      ),
      );
  }
}