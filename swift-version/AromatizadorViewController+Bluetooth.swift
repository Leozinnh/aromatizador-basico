import CoreBluetooth
import UIKit

// MARK: - Button Actions
extension AromatizadorViewController {
    
    @objc private func scanButtonTapped() {
        if isScanning {
            stopScanning()
        } else {
            startScanning()
        }
    }
    
    @objc private func connectButtonTapped() {
        if connectedPeripheral != nil {
            disconnect()
        } else {
            // This would normally connect to a selected peripheral
            // For now, we'll simulate a connection
            simulateConnection()
        }
    }
    
    @objc private func sendConfigButtonTapped() {
        guard connectedPeripheral != nil else {
            showAlert(title: "Erro", message: "Conecte-se primeiro ao dispositivo")
            return
        }
        
        sendConfiguration()
    }
    
    @objc private func intensityChanged(_ sender: UISlider) {
        intensity = Int(sender.value)
    }
    
    @objc private func intervalChanged(_ sender: UISlider) {
        interval = Int(sender.value)
    }
}

// MARK: - Bluetooth Setup and Methods
extension AromatizadorViewController {
    
    private func setupBluetooth() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    private func startScanning() {
        guard centralManager.state == .poweredOn else {
            showAlert(title: "Bluetooth", message: "Bluetooth não está disponível")
            return
        }
        
        isScanning = true
        updateScanButton()
        updateStatus(icon: "magnifyingglass", text: "Procurando dispositivos...", color: .systemBlue)
        
        // Start scanning for peripherals
        centralManager.scanForPeripherals(withServices: nil, options: nil)
        
        // Stop scanning after 10 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.stopScanning()
            self.simulateDeviceFound()
        }
    }
    
    private func stopScanning() {
        centralManager.stopScan()
        isScanning = false
        updateScanButton()
    }
    
    private func simulateDeviceFound() {
        updateStatus(icon: "bluetooth", text: "Aromatizador encontrado!", color: .systemGreen)
        connectButton.isEnabled = true
        connectButton.alpha = 1.0
    }
    
    private func simulateConnection() {
        updateStatus(icon: "bluetooth.circle", text: "Conectando...", color: .systemYellow)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.updateStatus(icon: "bluetooth.circle.fill", text: "Conectado ao Aromatizador", color: .systemGreen)
            self.connectButton.setTitle("Desconectar", for: .normal)
            self.connectButton.setImage(UIImage(systemName: "bluetooth.slash"), for: .normal)
            self.connectButton.backgroundColor = .systemOrange
            
            self.sendConfigButton.isEnabled = true
            self.sendConfigButton.alpha = 1.0
            
            // Simulate a connected peripheral
            self.connectedPeripheral = CBPeripheral()
            
            self.showAlert(title: "Sucesso", message: "Conectado com sucesso ao aromatizador!")
        }
    }
    
    private func disconnect() {
        if let peripheral = connectedPeripheral {
            centralManager.cancelPeripheralConnection(peripheral)
        }
        
        connectedPeripheral = nil
        updateStatus(icon: "bluetooth.slash", text: "Desconectado", color: .systemGray)
        
        connectButton.setTitle("Conectar", for: .normal)
        connectButton.setImage(UIImage(systemName: "bluetooth"), for: .normal)
        connectButton.backgroundColor = .systemBlue
        connectButton.isEnabled = false
        connectButton.alpha = 0.6
        
        sendConfigButton.isEnabled = false
        sendConfigButton.alpha = 0.6
        
        showAlert(title: "Desconectado", message: "Dispositivo desconectado")
    }
    
    private func sendConfiguration() {
        let message = "Enviando configuração:\nIntensidade: \(intensity)%\nIntervalo: \(interval) minutos"
        
        // Here you would send the actual Bluetooth command
        // For simulation, we just show an alert
        showAlert(title: "Configuração Enviada", message: message)
        
        // In a real implementation, you would write to the characteristic:
        // peripheral.writeValue(configData, for: characteristic, type: .withResponse)
    }
}

// MARK: - UI Update Methods
extension AromatizadorViewController {
    
    private func updateScanButton() {
        if isScanning {
            scanButton.setTitle("Parando...", for: .normal)
            scanButton.setImage(UIImage(systemName: "stop.circle"), for: .normal)
            scanButton.isEnabled = false
            scanButton.alpha = 0.6
        } else {
            scanButton.setTitle("Buscar Dispositivo", for: .normal)
            scanButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            scanButton.isEnabled = true
            scanButton.alpha = 1.0
        }
    }
    
    private func updateStatus(icon: String, text: String, color: UIColor) {
        DispatchQueue.main.async {
            self.statusIcon.image = UIImage(systemName: icon)
            self.statusIcon.tintColor = color
            self.statusLabel.text = text
        }
    }
    
    private func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

// MARK: - CBCentralManagerDelegate
extension AromatizadorViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            updateStatus(icon: "bluetooth", text: "Bluetooth pronto", color: .systemBlue)
        case .poweredOff:
            updateStatus(icon: "bluetooth.slash", text: "Bluetooth desligado", color: .systemRed)
        case .unsupported:
            updateStatus(icon: "exclamationmark.triangle", text: "Bluetooth não suportado", color: .systemRed)
        default:
            updateStatus(icon: "bluetooth.slash", text: "Bluetooth indisponível", color: .systemGray)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Filter for your specific device here
        // For example, check if peripheral.name contains "Aromatizador"
        if let name = peripheral.name, name.lowercased().contains("aroma") {
            stopScanning()
            updateStatus(icon: "bluetooth", text: "Aromatizador encontrado!", color: .systemGreen)
            connectButton.isEnabled = true
            connectButton.alpha = 1.0
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectedPeripheral = peripheral
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        
        updateStatus(icon: "bluetooth.circle.fill", text: "Conectado ao Aromatizador", color: .systemGreen)
        connectButton.setTitle("Desconectar", for: .normal)
        connectButton.setImage(UIImage(systemName: "bluetooth.slash"), for: .normal)
        connectButton.backgroundColor = .systemOrange
        
        sendConfigButton.isEnabled = true
        sendConfigButton.alpha = 1.0
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        updateStatus(icon: "exclamationmark.triangle", text: "Falha na conexão", color: .systemRed)
        showAlert(title: "Erro", message: "Não foi possível conectar ao dispositivo")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        connectedPeripheral = nil
        disconnect()
    }
}

// MARK: - CBPeripheralDelegate
extension AromatizadorViewController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        // Here you would identify the specific characteristics you need
        // For example, find the characteristic for sending configuration data
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            showAlert(title: "Erro", message: "Falha ao enviar configuração: \(error.localizedDescription)")
        } else {
            showAlert(title: "Sucesso", message: "Configuração enviada com sucesso!")
        }
    }
}
