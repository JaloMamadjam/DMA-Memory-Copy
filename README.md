# MIPS SoC Hardware Accelerator: DMA Memory Copy

Este repositório contém o projeto final da disciplina de **Linguagem de Descrição de Hardware (LDH)**, focado no desenvolvimento de um *System-on-Chip* (SoC) baseado no processador **MIPS_S**.

O objetivo principal foi projetar, implementar e comparar duas abordagens para a transferência de blocos de memória (*memcpy*): uma via **Software (Assembly)** e outra via **Hardware Dedicado (DMA)**, demonstrando o ganho de desempenho obtido com a aceleração por hardware.

## 🚀 Visão Geral do Projeto

O sistema foi desenvolvido para realizar a cópia de um bloco de texto (~1.5KB) de uma região de memória de origem para uma de destino. O projeto é dividido em três etapas incrementais:

1.  **Projeto 2 (Assembly):** Implementação do algoritmo `strcpy` em Assembly MIPS.
2.  **Projeto 3 (Simulação de Software):** Validação do software rodando no processador MIPS_S simulado.
3.  **Projeto 4 (Aceleração por Hardware):** Desenvolvimento de um periférico **DMA (Direct Memory Access)** em VHDL que assume o controle do barramento e realiza a cópia de forma autônoma.

## 🛠️ Tecnologias Utilizadas

* **Linguagem de Hardware:** VHDL
* **Linguagem de Software:** Assembly MIPS
* **Arquitetura:** Processador MIPS_S (Multiciclo) com BRAMs
* **Ferramentas:** Xilinx ISE Design Suite / Vivado, Simulador MARS
* **Plataforma Alvo:** FPGA Digilent Nexys 2 (Spartan-3E) / Nexys 1 (Spartan-3)

## 📊 Comparação de Desempenho (Benchmark)

A principal contribuição deste projeto é a análise comparativa entre a execução puramente por software e a execução acelerada por hardware.

| Métrica | Software (CPU MIPS) | Hardware (DMA Controller) |
| :--- | :--- | :--- |
| **Método** | Instruções (`lbu`, `sb`, `addi`...) | FSM Dedicada (Burst Mode) |
| **Custo por Byte** | ~24 Ciclos de Clock | **3 Ciclos de Clock** |
| **Tempo Total** | ~720 µs | **~90 µs** |
| **Speedup** | 1x (Base) | **~8x mais rápido** |

> **Conclusão:** O hardware dedicado elimina o *overhead* de busca e decodificação de instruções (Fetch/Decode), saturando a largura de banda da memória e atingindo uma eficiência 800% superior.

## 📂 Estrutura do Repositório

```text
.
├── 📁 Docs/                  # Relatório técnico e especificações
├── 📁 Project2_Assembly/     # Código fonte Assembly (.asm) comentado
├── 📁 Project3_Sim/          # Testbench para validação de software (MIPS_S_Sim)
├── 📁 Project4_Hardware/     # Código VHDL do SoC Completo
│   ├── DMA_Controller.vhd    # O Acelerador de Hardware (Periférico)
│   ├── Top_System_Root.vhd   # Integração MIPS + DMA
│   ├── MIPS_S_Core/          # Fontes do processador MIPS_S
│   └── Constraints.ucf       # Pinagem para FPGA Nexys
└── 📁 FPGA_Bitstream/        # Arquivo .bit para gravação na placa
