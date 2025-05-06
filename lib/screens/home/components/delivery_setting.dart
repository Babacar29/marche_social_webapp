import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marche_social_webapp/controllers/deliver/deliver_controller.dart';
import 'package:marche_social_webapp/core/models/Zone.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../core/utils/Utils.dart';

class DeliverySetupScreen extends StatefulWidget {
  const DeliverySetupScreen({super.key});

  @override
  State<DeliverySetupScreen> createState() => _DeliverySetupScreenState();
}

class _DeliverySetupScreenState extends State<DeliverySetupScreen> {
  DeliverController deliverController = Get.find<DeliverController>();
  List<Zone> sellerZones = [];

  final List<String> allSlots = ["2h", "4h", "6h", "24h"];

  // Ajouter une nouvelle zone vendeur (Tableau 1)
  void addNewSellerZone() {
    showDialog(
      context: context,
      builder: (context) {
        String? selectedZone;
        return AlertDialog(
          title: const Text("Ajouter une zone"),
          content: DropdownButtonFormField<String>(
            hint: const Text("Sélectionnez un code postal"),
            decoration: const InputDecoration(
              border: InputBorder.none,
              disabledBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
            ),
            value: selectedZone,
            isExpanded: true,
            items: Utils().allPostalCodes().map((String code) {
              return DropdownMenuItem<String>(
                value: code,
                child: Text(code),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                selectedZone = value;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                if (selectedZone != null && !sellerZones.any((zone) => zone.code == selectedZone)) {
                  setState(() {
                    sellerZones.add(Zone(selectedZone!, [], []));
                  }); 
                  addNewBuyerZone(sellerZones.length - 1); // Ajouter une zone acheteur après avoir ajouté la zone vendeur
                  Navigator.pop(context);
                } else {
                  Utils().showCustomSnackBar("", "Veuillez sélectionner un code postal unique");
                }
              },
              child: const Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }

  // Supprimer une zone vendeur (Tableau 1)
  void removeSellerZone(int index) {
    setState(() {
      sellerZones.removeAt(index);
    });
    deliverController.saveDeliverAgentSchedulesToFirestore(sellerZones: sellerZones);
  }

  // Ajouter une nouvelle zone acheteur (Tableau 2)
  void addNewBuyerZone(int sellerIndex) {
    setState(() {
      // Récupérer le code postal de la zone vendeur
      String defaultPostalCode = sellerZones[sellerIndex].code; // Si tu veux pré-remplir avec le code du vendeur
      // Ajouter une nouvelle BuyerZone avec le code postal par défaut ou vide
      sellerZones[sellerIndex].buyerZones.add(BuyerZone(defaultPostalCode, []));
    });
    //debugPrint("buyerZones: ${sellerZones[sellerIndex].buyerZones[sellerIndex].code}");
  }

  // Supprimer une zone acheteur (Tableau 2)
  void removeBuyerZone(int sellerIndex, int buyerIndex) {
    setState(() {
      sellerZones[sellerIndex].buyerZones.removeAt(buyerIndex);
    });
    deliverController.saveDeliverAgentSchedulesToFirestore(sellerZones: sellerZones);
  }

  // Récupérer les zones depuis Firestore
  void getZones() {
    deliverController.fetchDeliveryZones().then((_) {
      if (!mounted) return;
      setState(() {
        sellerZones = deliverController.sellerZones;
      });
    });
  }

  @override
  void initState() {
    getZones();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Padding(
      padding: EdgeInsets.only(left: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tableau 1 : Zones vendeurs
          sellerZones.isEmpty
              ? const SizedBox()
              : const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Zone de récupération des commandes (chez les vendeurs)",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
          sellerZones.isEmpty
              ? const SizedBox()
              : DataTable(
                  columnSpacing: 14.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  headingRowColor: WidgetStateColor.resolveWith((states) => Colors.grey[900]!),
                  dataRowColor: WidgetStateColor.resolveWith((states) => Colors.black87),
                  columns: [
                    const DataColumn(
                      label: Text("Zones Vendeurs", style: TextStyle(color: Colors.white)),
                    ),
                    DataColumn(
                      label: Padding(
                        padding: EdgeInsets.only(left: 1.5.w),
                        child: const Text("Créneaux possibles", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const DataColumn(
                      label: Text("", style: TextStyle(color: Colors.white)), // Pour le bouton de suppression
                    ),
                  ],
                  rows: sellerZones.asMap().entries.map((entry) {
                    int index = entry.key;
                    Zone zone = entry.value;
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(zone.code, style: const TextStyle(color: Colors.white)),
                        ),
                        DataCell(
                          Row(
                            children: allSlots.map((slot) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 1.5.w),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: zone.slots.contains(slot),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            zone.slots.add(slot);
                                          } else {
                                            zone.slots.remove(slot);
                                            // Désélectionner ce créneau dans toutes les zones acheteurs associées
                                            for (var buyerZone in zone.buyerZones) {
                                              buyerZone.slots.remove(slot);
                                            }
                                          }
                                        });
                                      },
                                      activeColor: Colors.green,
                                    ),
                                    Text(slot, style: const TextStyle(color: Colors.white)),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removeSellerZone(index),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
          SizedBox(height: height / 40),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  addNewSellerZone();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  "Ajouter une zone",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Fonctionnalité : Le livreur sélectionne une zone et coche les créneaux disponibles.",
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ),
          SizedBox(height: 5.h),
          // Tableau 2 : Zones acheteurs pour chaque zone vendeur
          sellerZones.any((zone) => zone.buyerZones.isNotEmpty) // Vérifie s'il y a des zones acheteurs
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Zone de livraison des commandes (chez les acheteurs)",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      DataTable(
                        columnSpacing: 15.5.w,
                        headingRowColor: WidgetStateColor.resolveWith((states) => Colors.grey[900]!),
                        dataRowColor: WidgetStateColor.resolveWith((states) => Colors.black87),
                        columns: [
                          const DataColumn(
                            label: Text("Zone vendeur", style: TextStyle(color: Colors.white)),
                          ),
                          DataColumn(
                            label: Padding(
                              padding: EdgeInsets.only(left: 1.5.w),
                              child: const Text("Créneaux possibles", style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          const DataColumn(
                            label: Text("", style: TextStyle(color: Colors.white)), // Colonne pour le bouton de suppression
                          ),
                        ],
                        rows: sellerZones.asMap().entries.expand((entry) {
                          int sellerIndex = entry.key;
                          Zone sellerZone = entry.value;
                          return sellerZone.buyerZones.asMap().entries.map((buyerEntry) {
                            int buyerIndex = buyerEntry.key;
                            BuyerZone buyerZone = buyerEntry.value;
                            return DataRow(
                              cells: [
                                // Nouvelle colonne pour afficher la zone vendeur associée
                                DataCell(
                                  Text(sellerZone.code, style: const TextStyle(color: Colors.white)),
                                ),
                                /* DataCell(
                                  TextField(
                                    controller: TextEditingController(text: buyerZone.code),
                                    onChanged: (newValue) {
                                      setState(() {
                                        buyerZone.code = newValue;
                                      });
                                    },
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      hintText: "Entrez le code postal",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ), */
                                DataCell(
                                  Row(
                                    children: allSlots.map((slot) {
                                      bool isAvailable = sellerZone.slots.contains(slot);
                                      return Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 1.5.w),
                                        child: Row(
                                          children: [
                                            Checkbox(
                                              value: buyerZone.slots.contains(slot),
                                              onChanged: isAvailable
                                                  ? (bool? value) {
                                                      setState(() {
                                                        if (value == true) {
                                                          buyerZone.slots.add(slot);
                                                        } else {
                                                          buyerZone.slots.remove(slot);
                                                        }
                                                      });
                                                    }
                                                  : null,
                                              activeColor: Colors.green,
                                            ),
                                            Text(
                                              slot,
                                              style: TextStyle(
                                                color: isAvailable ? Colors.white : Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                               const  DataCell(
                                   SizedBox()
                                  /*IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      removeBuyerZone(sellerIndex, buyerIndex),
                                    }
                                  ),*/
                                ),
                              ],
                            );
                          });
                        }).toList(),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          /* ...sellerZones.asMap().entries.map((entry) {
            int sellerIndex = entry.key;
            Zone sellerZone = entry.value;
            return sellerZone.buyerZones.isEmpty
                    ? const SizedBox()
                    : DataTable(
                  columnSpacing: 12.w,
                  headingRowColor: WidgetStateColor.resolveWith((states) => Colors.grey[900]!),
                  dataRowColor: WidgetStateColor.resolveWith((states) => Colors.black87),
                  columns: [
                    const DataColumn(
                      label: Text("Zones acheteurs", style: TextStyle(color: Colors.white)),
                    ),
                    DataColumn(
                      label: Padding(
                        padding: EdgeInsets.only(left: 1.5.w),
                        child: const Text("Créneaux possibles", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const DataColumn(
                      label: Text("", style: TextStyle(color: Colors.white)), // Colonne pour le bouton de suppression
                    ),
                  ],
                  rows: sellerZone.buyerZones.asMap().entries.map((buyerEntry) {
                    int buyerIndex = buyerEntry.key;
                    BuyerZone buyerZone = buyerEntry.value;
                    return DataRow(
                      cells: [
                        DataCell(
                          // Champ éditable pour le code postal
                          TextField(
                            controller: TextEditingController(text: buyerZone.code),
                            onChanged: (newValue) {
                              setState(() {
                                buyerZone.code = newValue; // Met à jour le code postal en temps réel
                              });
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "Entrez le code postal",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        DataCell(
                          Row(
                            children: allSlots.map((slot) {
                              bool isAvailable = sellerZone.slots.contains(slot);
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 1.5.w),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: buyerZone.slots.contains(slot),
                                      onChanged: isAvailable
                                          ? (bool? value) {
                                              setState(() {
                                                if (value == true) {
                                                  buyerZone.slots.add(slot);
                                                } else {
                                                  buyerZone.slots.remove(slot);
                                                }
                                              });
                                            }
                                          : null,
                                      activeColor: Colors.green,
                                    ),
                                    Text(
                                      slot,
                                      style: TextStyle(
                                        color: isAvailable ? Colors.white : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removeBuyerZone(sellerIndex, buyerIndex),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                );
          }), */
          SizedBox(height: height / 40),
          sellerZones.isEmpty
              ? const SizedBox()
              : SizedBox(
                  child: ElevatedButton(
                    onPressed: () {
                      deliverController.saveDeliverAgentSchedulesToFirestore(sellerZones: sellerZones);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                    child: const Text(
                      "  Tout enregistrer  ",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}



/* import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marche_social_webapp/controllers/deliver/deliver_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../core/models/Zone.dart';
import '../../../core/utils/Utils.dart';

class DeliverySetupScreen extends StatefulWidget {
  const DeliverySetupScreen({super.key});

  @override
  State<DeliverySetupScreen> createState() => _DeliverySetupScreenState();
}

class _DeliverySetupScreenState extends State<DeliverySetupScreen> {
  DeliverController deliverController = Get.find<DeliverController>();
  List<Zone> sellerZones = [];
  List<Zone> buyerZones = [];


  final List<String> allSlots = ["2h", "4h", "6h", "24h"];

  // Ajouter une nouvelle zone vendeur (Tableau 1)
  void addNewSellerZone() {
    showDialog(
      context: context,
      builder: (context) {
        String? selectedZone;
        return AlertDialog(
          title: const Text("Ajouter une zone"),
          content: DropdownButtonFormField<String>(
            hint: const Text("Sélectionnez un code postal"),
            decoration: const InputDecoration(
              border: InputBorder.none,
              disabledBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
             contentPadding: EdgeInsets.symmetric(horizontal: 10)
            ),
            value: selectedZone,
            isExpanded: true,
            items: Utils().allPostalCodes().map((String code) {
              return DropdownMenuItem<String>(
                value: code,
                child: Text(code),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                selectedZone = value;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                if (selectedZone != null && !sellerZones.any((zone) => zone.code == selectedZone)) {
                  setState(() {
                    sellerZones.add(Zone(selectedZone!, []));
                    buyerZones.add(Zone(selectedZone!, []));
                  });
                  Navigator.pop(context);
                } else {
                  Utils().showCustomSnackBar("", "Veuillez sélectionner un code postal unique");
                }
              },
              child: const Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }

  // Supprimer une zone vendeur (Tableau 1)
  void removeSellerZone(int index) {
    setState(() {
      sellerZones.removeAt(index);
      buyerZones.removeAt(index);
    });
    deliverController.saveDeliverAgentSchedulesToFirestore(sellerZones: sellerZones, buyerZones: buyerZones);
  }

  // Ajouter une nouvelle zone acheteur (Tableau 2)
  void addNewBuyerZone() {
    showDialog(
      context: context,
      builder: (context) {
        String newBuyerZone = "";
        return AlertDialog(
          title: const Text("Ajouter une zone acheteur"),
          content: TextField(
            decoration:  const InputDecoration(labelText: "Code postal (ex. 75020)"),
            onChanged: (value) => newBuyerZone = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                if (newBuyerZone.isNotEmpty) {
                  setState(() {
                    buyerZones.add(Zone(newBuyerZone, []));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }

  // Supprimer une zone acheteur (Tableau 2)
  void removeBuyerZone(int buyerIndex) {
    setState(() {
      buyerZones.removeAt(buyerIndex);
      sellerZones.removeAt(buyerIndex);
    });
    deliverController.saveDeliverAgentSchedulesToFirestore(sellerZones: sellerZones, buyerZones: buyerZones);
  }

  getZones(){
    deliverController.fetchDeliveryZones().then((_){
      if(!mounted) return;
      setState(() {
        sellerZones = deliverController.sellerZones;
        buyerZones = deliverController.buyerZones;
      });
    });
  }

  @override
  void initState() {
    getZones();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    //final width = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: EdgeInsets.only(left: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tableau 1 : Zones vendeurs
          sellerZones.isEmpty ? const SizedBox() : const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Zone de récupération des commandes (chez les vendeurs)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          sellerZones.isEmpty ? const SizedBox() : DataTable(
            columnSpacing: 10.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5)
            ),
            headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[900]!),
            dataRowColor: MaterialStateColor.resolveWith((states) => Colors.black87),
            columns: [
              const DataColumn(
                label: Text("Zones Vendeurs", style: TextStyle(color: Colors.white)),
              ),
              DataColumn(
                label: Padding(
                  padding: EdgeInsets.only(left: 1.5.w),
                  child: const Text("Créneaux possibles", style: TextStyle(color: Colors.white)),
                ),
              ),
              const DataColumn(
                label: Text("", style: TextStyle(color: Colors.white)), // Pour le bouton de suppression
              ),
            ],
            rows: sellerZones.asMap().entries.map((entry) {
              int index = entry.key;
              Zone zone = entry.value;
              return DataRow(
                cells: [
                  DataCell(
                    Text(zone.code, style: const TextStyle(color: Colors.white)),
                  ),
                  DataCell(
                    Row(
                      children: allSlots.map((slot) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.5.w),
                          child: Row(
                            children: [
                              Checkbox(
                                value: zone.slots.contains(slot),
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      zone.slots.add(slot);
                                      buyerZones[index].slots.add(slot);
                                      /* if(!sellerZones[index].slots.contains(slot)){ 
                                        
                                      } */
                                    } else {
                                      zone.slots.remove(slot);
                                      buyerZones[index].slots.remove(slot);
                                    }
                                  });
                                },
                                activeColor: Colors.green,
                              ),
                              Text(slot, style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => removeSellerZone(index),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          SizedBox(height: height/40,),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  addNewSellerZone();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text("Ajouter une zone", style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Fonctionnalité : Le livreur sélectionne une zone et coche les créneaux disponibles.",
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ),
          SizedBox(height: 5.h,),

          // Tableau 2 : Zones acheteurs pour chaque zone vendeur
          buyerZones.isEmpty ? const SizedBox() : const Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Zone de livraison des commandes (chez les acheteurs)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          buyerZones.isEmpty ? const SizedBox() : DataTable(
            columnSpacing: 10.w,
            headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[900]!),
            dataRowColor: MaterialStateColor.resolveWith((states) => Colors.black87),
            columns: [
              const DataColumn(
                label: Text("Zones acheteurs", style: TextStyle(color: Colors.white)),
              ),
              DataColumn(
                label: Padding(
                  padding: EdgeInsets.only(left: 1.5.w),
                  child: const Text("Créneaux possibles", style: TextStyle(color: Colors.white)),
                ),
              ),
              const DataColumn(
                label: Text("", style: TextStyle(color: Colors.white)), // Pour le bouton de suppression
              ),
            ],
            rows: buyerZones.asMap().entries.map((buyerEntry) {
              int buyerIndex = buyerEntry.key;
              Zone buyerZone = buyerEntry.value;
              return DataRow(
                cells: [
                  DataCell(
                    Text(buyerZone.code, style: const TextStyle(color: Colors.white)),
                  ),
                  DataCell(
                    Row(
                      children: allSlots.map((slot) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.5.w),
                          child: Row(
                            children: [
                              Checkbox(
                                value: buyerZone.slots.contains(slot),
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      buyerZone.slots.add(slot);
                                      sellerZones[buyerIndex].slots.add(slot);
                                    } else {
                                      buyerZone.slots.remove(slot);
                                      sellerZones[buyerIndex].slots.remove(slot);
                                    }
                                  });
                                },
                                activeColor: Colors.green,
                              ),
                              Text(slot, style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => removeBuyerZone(buyerIndex),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          SizedBox(height: height/40,),
          sellerZones.isEmpty || buyerZones.isEmpty ? const SizedBox() : SizedBox(
            child: ElevatedButton(
              onPressed: () {
                //addNewSellerZone();
                deliverController.saveDeliverAgentSchedulesToFirestore(sellerZones: sellerZones, buyerZones: buyerZones);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
              child: const Text("  Tout enregistrer  ", style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
    /*Scaffold(
      appBar: AppBar(
        title: Text("Configurer mes disponibilités"),
        backgroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tableau 1 : Zones vendeurs
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Tableau 1 : Zones où il peut récupérer les commandes (chez les vendeurs)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[900]!),
                dataRowColor: MaterialStateColor.resolveWith((states) => Colors.black87),
                columns: [
                  DataColumn(
                    label: Text("Zone", style: TextStyle(color: Colors.white)),
                  ),
                  DataColumn(
                    label: Text("Créneaux possibles", style: TextStyle(color: Colors.white)),
                  ),
                  DataColumn(
                    label: Text("", style: TextStyle(color: Colors.white)), // Pour le bouton de suppression
                  ),
                ],
                rows: sellerZones.asMap().entries.map((entry) {
                  int index = entry.key;
                  SellerZone zone = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(zone.zone, style: TextStyle(color: Colors.white)),
                      ),
                      DataCell(
                        Row(
                          children: allSlots.map((slot) {
                            return Row(
                              children: [
                                Checkbox(
                                  value: zone.slots.contains(slot),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        zone.slots.add(slot);
                                      } else {
                                        zone.slots.remove(slot);
                                      }
                                    });
                                  },
                                  activeColor: Colors.green,
                                ),
                                Text(slot, style: TextStyle(color: Colors.white)),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      DataCell(
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removeSellerZone(index),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Fonctionnalité : Le livreur sélectionne une zone et coche les créneaux disponibles.",
                style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
              ),
            ),

            // Tableau 2 : Zones acheteurs pour chaque zone vendeur
            ...sellerZones.asMap().entries.map((entry) {
              int sellerIndex = entry.key;
              SellerZone sellerZone = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Tableau 2 : Zones acheteurs pour ${sellerZone.zone}",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 20,
                      headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[900]!),
                      dataRowColor: MaterialStateColor.resolveWith((states) => Colors.black87),
                      columns: [
                        DataColumn(
                          label: Text("Zone acheteur", style: TextStyle(color: Colors.white)),
                        ),
                        DataColumn(
                          label: Text("Créneaux possibles", style: TextStyle(color: Colors.white)),
                        ),
                        DataColumn(
                          label: Text("", style: TextStyle(color: Colors.white)), // Pour le bouton de suppression
                        ),
                      ],
                      rows: sellerZone.buyerZones.asMap().entries.map((buyerEntry) {
                        int buyerIndex = buyerEntry.key;
                        BuyerZone buyerZone = buyerEntry.value;
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(buyerZone.code, style: TextStyle(color: Colors.white)),
                            ),
                            DataCell(
                              Row(
                                children: allSlots.map((slot) {
                                  return Row(
                                    children: [
                                      Checkbox(
                                        value: buyerZone.slots.contains(slot),
                                        onChanged: (bool? value) {
                                          setState(() {
                                            if (value == true) {
                                              buyerZone.slots.add(slot);
                                            } else {
                                              buyerZone.slots.remove(slot);
                                            }
                                          });
                                        },
                                        activeColor: Colors.green,
                                      ),
                                      Text(slot, style: TextStyle(color: Colors.white)),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => removeBuyerZone(sellerIndex, buyerIndex),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => addNewBuyerZone(sellerIndex),
                      child: Text("Ajouter une zone acheteur"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    ),
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: addNewSellerZone,
            child: Icon(Icons.add),
            backgroundColor: Colors.blue,
            heroTag: "add_seller",
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: saveToFirestore,
            child: Icon(Icons.save),
            backgroundColor: Colors.green,
            heroTag: "save",
          ),
        ],
      ),
      backgroundColor: Colors.black87,
    );*/
  }
}


 */