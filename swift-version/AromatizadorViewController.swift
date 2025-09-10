import UIKit
import CoreBluetooth

class AromatizadorViewController: UIViewController {
    
    // MARK: - UI Elements
    private let statusView = UIView()
    private let statusIcon = UIImageView()
    private let statusLabel = UILabel()
    private let scanButton = UIButton(type: .system)
    private let connectButton = UIButton(type: .system)
    private let intensitySlider = UISlider()
    private let intensityLabel = UILabel()
    private let intervalSlider = UISlider()
    private let intervalLabel = UILabel()
    private let sendConfigButton = UIButton(type: .system)
    private let versionLabel = UILabel()
    
    // MARK: - Bluetooth Properties
    private var centralManager: CBCentralManager!
    private var connectedPeripheral: CBPeripheral?
    private var isScanning = false
    
    // MARK: - Configuration Properties
    private var intensity: Int = 50 {
        didSet {
            intensityLabel.text = "Intensidade: \(intensity)%"
        }
    }
    
    private var interval: Int = 30 {
        didSet {
            intervalLabel.text = "Intervalo: \(interval) minutos"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBluetooth()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Controlador Aromatizador"
        
        setupStatusView()
        setupButtons()
        setupSliders()
        setupLayout()
    }
    
    private func setupStatusView() {
        statusView.backgroundColor = .systemGray6
        statusView.layer.cornerRadius = 12
        statusView.translatesAutoresizingMaskIntoConstraints = false
        
        statusIcon.image = UIImage(systemName: "bluetooth.slash")
        statusIcon.tintColor = .systemGray
        statusIcon.contentMode = .scaleAspectFit
        statusIcon.translatesAutoresizingMaskIntoConstraints = false
        
        statusLabel.text = "Desconectado"
        statusLabel.textAlignment = .center
        statusLabel.font = .systemFont(ofSize: 18, weight: .medium)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        statusView.addSubview(statusIcon)
        statusView.addSubview(statusLabel)
    }
    
    private func setupButtons() {
        // Scan Button
        scanButton.setTitle("Buscar Dispositivo", for: .normal)
        scanButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        scanButton.backgroundColor = .systemBlue
        scanButton.setTitleColor(.white, for: .normal)
        scanButton.tintColor = .white
        scanButton.layer.cornerRadius = 8
        scanButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        scanButton.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Connect Button
        connectButton.setTitle("Conectar", for: .normal)
        connectButton.setImage(UIImage(systemName: "bluetooth"), for: .normal)
        connectButton.backgroundColor = .systemBlue
        connectButton.setTitleColor(.white, for: .normal)
        connectButton.tintColor = .white
        connectButton.layer.cornerRadius = 8
        connectButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        connectButton.addTarget(self, action: #selector(connectButtonTapped), for: .touchUpInside)
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        connectButton.isEnabled = false
        connectButton.alpha = 0.6
        
        // Send Config Button
        sendConfigButton.setTitle("Enviar Configuração", for: .normal)
        sendConfigButton.setImage(UIImage(systemName: "paperplane"), for: .normal)
        sendConfigButton.backgroundColor = .systemGreen
        sendConfigButton.setTitleColor(.white, for: .normal)
        sendConfigButton.tintColor = .white
        sendConfigButton.layer.cornerRadius = 8
        sendConfigButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        sendConfigButton.addTarget(self, action: #selector(sendConfigButtonTapped), for: .touchUpInside)
        sendConfigButton.translatesAutoresizingMaskIntoConstraints = false
        sendConfigButton.isEnabled = false
        sendConfigButton.alpha = 0.6
        
        // Version Label
        versionLabel.text = "Versão: 1.0.0 (Swift Nativo)"
        versionLabel.textAlignment = .center
        versionLabel.font = .systemFont(ofSize: 12)
        versionLabel.textColor = .systemGray
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupSliders() {
        // Intensity Slider
        intensityLabel.text = "Intensidade: \(intensity)%"
        intensityLabel.font = .systemFont(ofSize: 16, weight: .medium)
        intensityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        intensitySlider.minimumValue = 0
        intensitySlider.maximumValue = 100
        intensitySlider.value = Float(intensity)
        intensitySlider.addTarget(self, action: #selector(intensityChanged), for: .valueChanged)
        intensitySlider.translatesAutoresizingMaskIntoConstraints = false
        
        // Interval Slider
        intervalLabel.text = "Intervalo: \(interval) minutos"
        intervalLabel.font = .systemFont(ofSize: 16, weight: .medium)
        intervalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        intervalSlider.minimumValue = 5
        intervalSlider.maximumValue = 120
        intervalSlider.value = Float(interval)
        intervalSlider.addTarget(self, action: #selector(intervalChanged), for: .valueChanged)
        intervalSlider.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLayout() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        let configView = UIView()
        configView.backgroundColor = .systemGray6
        configView.layer.cornerRadius = 12
        configView.translatesAutoresizingMaskIntoConstraints = false
        
        let configTitle = UILabel()
        configTitle.text = "Configurações"
        configTitle.font = .systemFont(ofSize: 20, weight: .bold)
        configTitle.translatesAutoresizingMaskIntoConstraints = false
        
        // Add all subviews
        contentView.addSubview(statusView)
        contentView.addSubview(scanButton)
        contentView.addSubview(connectButton)
        contentView.addSubview(configTitle)
        contentView.addSubview(configView)
        contentView.addSubview(sendConfigButton)
        contentView.addSubview(versionLabel)
        
        configView.addSubview(intensityLabel)
        configView.addSubview(intensitySlider)
        configView.addSubview(intervalLabel)
        configView.addSubview(intervalSlider)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Status View
            statusView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            statusView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statusView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            statusView.heightAnchor.constraint(equalToConstant: 120),
            
            // Status Icon
            statusIcon.centerXAnchor.constraint(equalTo: statusView.centerXAnchor),
            statusIcon.topAnchor.constraint(equalTo: statusView.topAnchor, constant: 20),
            statusIcon.widthAnchor.constraint(equalToConstant: 40),
            statusIcon.heightAnchor.constraint(equalToConstant: 40),
            
            // Status Label
            statusLabel.centerXAnchor.constraint(equalTo: statusView.centerXAnchor),
            statusLabel.topAnchor.constraint(equalTo: statusIcon.bottomAnchor, constant: 12),
            statusLabel.leadingAnchor.constraint(equalTo: statusView.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: statusView.trailingAnchor, constant: -16),
            
            // Scan Button
            scanButton.topAnchor.constraint(equalTo: statusView.bottomAnchor, constant: 24),
            scanButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            scanButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            scanButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Connect Button
            connectButton.topAnchor.constraint(equalTo: scanButton.bottomAnchor, constant: 12),
            connectButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            connectButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            connectButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Config Title
            configTitle.topAnchor.constraint(equalTo: connectButton.bottomAnchor, constant: 32),
            configTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            // Config View
            configView.topAnchor.constraint(equalTo: configTitle.bottomAnchor, constant: 16),
            configView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            configView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Intensity Label
            intensityLabel.topAnchor.constraint(equalTo: configView.topAnchor, constant: 16),
            intensityLabel.leadingAnchor.constraint(equalTo: configView.leadingAnchor, constant: 16),
            intensityLabel.trailingAnchor.constraint(equalTo: configView.trailingAnchor, constant: -16),
            
            // Intensity Slider
            intensitySlider.topAnchor.constraint(equalTo: intensityLabel.bottomAnchor, constant: 8),
            intensitySlider.leadingAnchor.constraint(equalTo: configView.leadingAnchor, constant: 16),
            intensitySlider.trailingAnchor.constraint(equalTo: configView.trailingAnchor, constant: -16),
            
            // Interval Label
            intervalLabel.topAnchor.constraint(equalTo: intensitySlider.bottomAnchor, constant: 24),
            intervalLabel.leadingAnchor.constraint(equalTo: configView.leadingAnchor, constant: 16),
            intervalLabel.trailingAnchor.constraint(equalTo: configView.trailingAnchor, constant: -16),
            
            // Interval Slider
            intervalSlider.topAnchor.constraint(equalTo: intervalLabel.bottomAnchor, constant: 8),
            intervalSlider.leadingAnchor.constraint(equalTo: configView.leadingAnchor, constant: 16),
            intervalSlider.trailingAnchor.constraint(equalTo: configView.trailingAnchor, constant: -16),
            intervalSlider.bottomAnchor.constraint(equalTo: configView.bottomAnchor, constant: -16),
            
            // Send Config Button
            sendConfigButton.topAnchor.constraint(equalTo: configView.bottomAnchor, constant: 24),
            sendConfigButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sendConfigButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            sendConfigButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Version Label
            versionLabel.topAnchor.constraint(equalTo: sendConfigButton.bottomAnchor, constant: 32),
            versionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            versionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}
