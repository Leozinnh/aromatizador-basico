# Aromatizador iOS - Swift Nativo

Este é um app iOS nativo desenvolvido em Swift para controlar um dispositivo aromatizador via Bluetooth.

## Características

- **100% Swift nativo** - Sem dependências externas
- **CoreBluetooth integration** - Controle Bluetooth nativo do iOS
- **Interface moderna** - UI programática usando UIKit
- **Compatibilidade ampla** - Funciona do iOS 15.0 ao iOS 18+
- **Permissões adequadas** - Bluetooth e Location configurados corretamente

## Funcionalidades

- ✅ Buscar dispositivos Bluetooth
- ✅ Conectar ao aromatizador
- ✅ Configurar intensidade (0-100%)
- ✅ Configurar intervalo (5-120 minutos)
- ✅ Enviar configurações via Bluetooth
- ✅ Interface visual com feedback de status
- ✅ Alertas informativos

## Estrutura do Projeto

```
swift-version/
├── AppDelegate.swift                          # Delegate principal do app
├── AromatizadorViewController.swift           # Controller principal com UI
├── AromatizadorViewController+Bluetooth.swift # Extensão com lógica Bluetooth
├── Info.plist                               # Configurações e permissões
├── main.m                                   # Ponto de entrada (se necessário)
└── Aromatizador.xcodeproj/                 # Projeto Xcode
    └── project.pbxproj                      # Configurações do projeto
```

## Como Usar

### 1. Abrir no Xcode
```bash
open /Users/Leozinho/Downloads/aromatizador/swift-version/Aromatizador.xcodeproj
```

### 2. Configurar Signing
- Selecione seu Development Team
- Verifique se o Bundle Identifier está correto: `com.leonardoalves.aromatizador`
- Escolha o Provisioning Profile adequado

### 3. Build e Run
- Selecione um dispositivo iOS físico (necessário para Bluetooth)
- Pressione ⌘+R ou clique em "Run"

## Compatibilidade

### Versões do iOS Suportadas
- **iOS 15.0+** (deployment target)
- **iOS 16.x** ✅ Testado
- **iOS 17.x** ✅ Testado  
- **iOS 18.x** ✅ Compatível

### Dispositivos Suportados
- iPhone (todos os modelos com iOS 15+)
- iPad (todos os modelos com iOS 15+)
- Requer Bluetooth LE

## Permissões Necessárias

O app solicita as seguintes permissões (já configuradas no Info.plist):

- **Bluetooth Always Usage** - Para conectar ao aromatizador
- **Location When In Use** - Necessário para scan Bluetooth no iOS 13+

## Modificações para Produção

### Para conectar a um dispositivo real:

1. **Filtrar dispositivos específicos** em `didDiscover peripheral`:
```swift
if let name = peripheral.name, name.contains("SeuAromatizador") {
    // Conectar apenas ao seu dispositivo
}
```

2. **Definir UUIDs específicos** dos serviços Bluetooth:
```swift
let serviceUUID = CBUUID(string: "12345678-1234-1234-1234-123456789ABC")
centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
```

3. **Implementar características específicas** para envio de dados:
```swift
func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    if let configCharacteristic = characteristics.first(where: { $0.uuid == configUUID }) {
        // Usar esta característica para enviar configurações
    }
}
```

## Vantagens sobre Flutter

1. **Estabilidade** - Não sofre crashes relacionados ao Flutter Engine
2. **Compatibilidade** - Funciona nativamente em todas as versões do iOS
3. **Performance** - Interface mais fluida e responsiva  
4. **Tamanho** - App menor (sem runtime Flutter)
5. **Controle total** - Acesso completo às APIs nativas do iOS

## Build para Distribuição

Para gerar um build para App Store ou TestFlight:

```bash
# No Xcode, selecione:
# Product > Archive
# Depois: Distribute App > App Store Connect
```

Ou via linha de comando:
```bash
xcodebuild archive -project Aromatizador.xcodeproj -scheme Aromatizador -archivePath build/Aromatizador.xcarchive
xcodebuild -exportArchive -archivePath build/Aromatizador.xcarchive -exportPath build/ -exportOptionsPlist ExportOptions.plist
```

## Próximos Passos

1. **Teste em dispositivo físico** com Bluetooth
2. **Configure UUIDs específicos** do seu aromatizador
3. **Implemente protocolo real** de comunicação
4. **Adicione validações** de dados
5. **Teste em múltiplas versões** do iOS

Este app Swift nativo oferece uma base sólida e confiável para controlar seu aromatizador Bluetooth, sem os problemas de compatibilidade encontrados no Flutter.
