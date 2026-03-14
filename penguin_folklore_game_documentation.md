# Documentação do Jogo – Penguin Folklore Adventure (Título Provisório)

## 1. Visão Geral do Projeto

**Gênero:** Plataforma de Ação 2D / Metroidvania
**Engine:** Godot
**Ideia Central:**
Um pequeno pinguim, capaz de lançar projéteis mágicos de gelo e atacar corpo-a-corpo, viaja por diferentes regiões de um mundo místico onde criaturas de diversas mitologias (focando principalmente no folclore brasileiro, mas também incluindo algumas da mitologia de outras culturas) começaram a aparecer. O jogador explora biomas interconectados, resolve quebra-cabeças e derrota chefes para restaurar o equilíbrio do mundo.

---

## 2. Menus e Interface (UI)

Sistemas de interface já implementados:

- **Menu Inicial (Main Menu):** Tela de entrada do jogo.
- **Menu de Opções:** Configurações gerais do jogo (áudio, controles, tela).
- **Menu de Pausa:** Interrompe o jogo durante a partida.

---

## 3. Mecânicas do Jogador (Player)

**Habilidades Atuais:**

- Andar (Walk)
- Pulo (Jump) e Pulo Duplo (Double Jump)
- Agachar (Duck)
- Deslizar (Slide)
- Ataque Básico: Lançamento de bola de neve (Snowball)
- Pisar nos Inimigos (Stomp): Causa dano ao pular na cabeça
- Ataque Corpo-a-Corpo (Melee Attack)
- Habilidade de Nadar (swimming)
- Wall Jump (Pulo na parede)

  ### Sistemas de Sobrevivência (Vida e Mana):
  - **Vida (Health):** O jogador possui uma quantidade fixa de corações/pontos de vida. A vida não regenera automaticamente.
	- **Cura Ativa (Consumível Recarregável):** O jogador possui um estoque limitado de "Peixes Congelados" (Item de Cura). Ao consumir um peixe, o jogador recupera uma parte da vida.

	- **Recarga:** Os usos do Peixe Congelado são recarregados ao derrotar inimigos (que têm chance de dropar peixes menores) ou ao descansar em pontos de controle (Checkpoints).

	- **Upgrade:** O limite máximo de Peixes que o jogador pode carregar pode ser aumentado encontrando "Corações de Gelo" ou "Peixes Dourados" escondidos pelos cenários.

  - **Mana (Energia Mágica):** Utilizada para lançar projéteis (Bolas de Neve) e, no futuro, magias elementais.
	- Regeneração: A Mana se regenera automaticamente ao longo do tempo (ou a cada acerto corpo-a-corpo em inimigos).

	- Upgrade: A capacidade máxima de Mana pode ser expandida coletando "Cristais de Aurora Boreal" espalhados pelo mundo.

**Habilidades Futuras (Desbloqueáveis nos Bosses):**

- Dash (Investida rápida)
- Ataques de Fogo / Magias Elementais

---

## 4. Máquina de Estados do Jogador (State Machine)

Estados atuais controlados pelo script do Player:

- `idle` (Parado)
- `walk` (Andando)
- `jump` (Pulando)
- `fall` (Caindo)
- `duck` (Agachado)
- `slide` (Deslizando)
- `wall` (Deslizando/Agarrado na parede)
- `hurt` (Sofrendo dano)
- `swimming` (Nadando)
- `attack` (Atacando com projétil)
- `meeleAttack` (Ataque corpo-a-corpo)

---

## 5. Sistema de Inimigos

O projeto utiliza nós do tipo `Area2D` para hitboxes e detecção.

- **Hitbox da Cabeça:** Vulnerável a pulos do jogador.
- **Hitbox do Corpo:** Causa dano de contato ao jogador se tocado.

**Inimigos Atuais Implementados:**

1. **Esqueleto (Skeleton):** Inimigo básico (Estados: Andar, Atacar, Sofrer Dano).
2. **Minotauro:** Criatura bruta da mitologia grega (representa a quebra das barreiras mitológicas).
3. **Lord Boto:** Inimigo poderoso e sedutor baseado no Boto Cor-de-Rosa (Folclore Brasileiro).

**Inteligência Artificial (IA) Base:**

- Patrulhamento de uma área delimitada.
- Detecção do jogador (Linha de visão ou proximidade via `RayCast2D` / `Area2D`).
- Perseguição e execução de ataque.

---

## 6. Sistema de Chefes (Bosses) - Planejamento

Cada bioma do jogo terá um chefe baseado no folclore brasileiro. Ao derrotá-los, o jogador ganhará uma nova habilidade para acessar áreas antes bloqueadas.
**Possíveis Chefes:**

- **Curupira:** Boss da Floresta Mágica (Desbloqueia o Dash).
- **Cuca:** Boss do Pântano (Desbloqueia Magia/Ataques Especiais).
- **Iara:** Boss do Rio/Caverna (Desbloqueia a habilidade de Nadar).
- **Boitatá:** Boss de Bioma Vulcânico/Subterrâneo (Desbloqueia resistência ao fogo ou ataque de fogo).

---

## 7. Estrutura do Mundo (Level Design Metroidvania)

O mundo será dividido em regiões interconectadas.

1. **Montanhas Congeladas:** Área tutorial e ponto de partida.
2. **Floresta Mágica:** Introdução de plataformas móveis e inimigos variados do folclore.
3. **Ruínas Antigas na Selva:** Puzzles antigos, foco em verticalidade.
4. **Pântano Místico:** Áreas com água venenosa, necessidade de pulo duplo/dash.
5. **Cavernas Subterrâneas:** Labirintos escuros, uso de magias de luz/fogo.

### Elementos de Exploração e Recompensa:

- **Checkpoints (Santuários/Fogueiras):** Locais seguros onde o jogador salva o jogo, recupera toda a Vida e recarrega seus Peixes Congelados. Os inimigos da região renascem ao usar um Checkpoint.

- **Coletáveis de Melhoria (Upgrades):**
  - **Corações de Gelo:** Aumentam a Vida Máxima ou a capacidade de carregar Peixes Congelados.

  - **Cristais de Aurora Boreal:** Aumentam a capacidade máxima de Mana.

---

## 8. Lore e História (Conceito Inicial)

Um artefato mágico, que sempre manteve as fronteiras entre os vários mundos mitológicos isoladas, foi misteriosamente estilhaçado. Como resultado, o mundo começou a sofrer fusões dimensionais: lendas do folclore brasileiro e criaturas de outras mitologias começaram a invadir a mesma realidade.
O pinguim protagonista, outrora apenas um pacífico guardião de um antigo templo nas montanhas de gelo, se vê forçado a viajar pelas terras afetadas. Sua missão é derrotar as criaturas invasoras, recuperar os fragmentos do artefato e restaurar a ordem no universo.

---

## 9. Estrutura de Pastas e Arquitetura (Godot)

Recomendação de organização para manter o projeto limpo e escalável conforme ele cresce:

```text
res://
├── assets/
│   ├── audio/ (SFX e Músicas)
│   ├── fonts/
│   └── sprites/ (Imagens dividas por personagens, cenários, ui)
├── scenes/
│   ├── characters/
│   │   ├── player/
│   │   └── enemies/
│   │       ├── skeleton/
│   │       ├── minotaur/
│   │       └── lord_boto/
│   ├── levels/
│   │   ├── level_1_mountains/
│   │   └── level_2_forest/
│   ├── objects/ (Projetéteis, itens, plataformas)
│   └── ui/
│       ├── main_menu.tscn
│       ├── options_menu.tscn
│       └── pause_menu.tscn
├── scripts/
│   ├── singletons/ (Autoloads como GameManager.gd, AudioManager.gd)
│   ├── characters/
│   └── ui/
└── components/
	├── health_component.gd
	├── hitbox_component.gd
	└── state_machine.gd
```

---

## Dicas de Estruturação no Godot

Com base no seu atual estágio (onde você já tem menus e 3 inimigos distintos), aqui vão algumas dicas valiosas de arquitetura para a sua engine:

Use "Components" (Composição ao invés de Herança): Em vez de programar vida (Health) e dano no script do Player e depois repetir quase a mesma coisa nos scripts do Minotauro e do Lord Boto, crie Cenas pequenas separadas chamadas de "Componentes". Por exemplo:

HealthComponent (Guarda a vida atual, máxima e um sinal died)
HitboxComponent (Uma Area2D genérica focada apenas em receber dano)
HurtboxComponent (Uma Area2D genérica focada apenas em causar dano) Assim, para criar um inimigo novo, basta você arrastar esses componentes para dentro do seu novo nó de inimigo e conectar os Signals (Sinais). Isso vai salvar dezenas de horas de retrabalho!
Singletons (Autoload) para os Menus e o Estado do Jogo: Já que você tem os menus Base, Pause e Opções prontos, recomendo criar um script global (Autoload) chamado GameManager ou SceneManager. Esse script global pode ter funções como pause_game() e load_main_menu(). Isso evita com que seus botões tentem buscar os caminhos dos arquivos .tscn de forma engessada, facilitando muito se você decidir mudar pastas de lugar depois.

State Machine Modular: Vi que você listou vários estados do Player (idle, walk, jump...). Conforme o jogo crescer, colocar todos os if/else desses estados no \_physics_process do Player vai gerar um script gigante (código espaguete). Considere criar uma abordagem onde cada Estado virá um Nó (Node) (ex: nó IdleState, nó RunState), onde tudo o que for de execução ocorre dentro do script deste nó em específico. Isso permite reutilizar estados, por exemplo, fazer o inimigo e o player usarem o mesmo nó base de FallState.

## 10. Roadmap de Desenvolvimento

### Fase 1 – Protótipo (Concluído / Em Andamento)

- Controle e movimentação fluida do jogador.
- Implementação inicial de inimigos diversos (Esqueleto, Minotauro, Lord Boto).
- Menus estruturados e funcionais (Principal, Opções, Pause).

### Fase 2 – Arquitetura e Componentes

- Refatorar comportamentos compartilhados (como Vida, Receber Dano, Causar Dano) usando uma arquitetura de Componentes.
- Centralizar o controle de fluxo do jogo com um Autoload Global (GameManager).
- Implementar transição suave entre Cenas/Mapas.

### Fase 3 – Expansão Metroidvania, Combate e Sobrevivência

- Criação do primeiro mapa completo.
- Implementação do Sistema de Cura Ativa (Consumo de Peixes e UI de estoque).
- Criação dos Coletáveis de Upgrade de Vida e Mana espalhados pelo mapa.
- Implementação do sistema de desbloqueio de habilidades (Habilidades presas a Chefes).
- Save System (Salvar progresso do jogador, inventário de coletáveis e upgrades).

### Fase 4 – Conteúdo e Bosses

- Design de novos biomas e quebra-cabeças.
- Criação dos chefões folclóricos (Curupira, etc.) e IA avançada.

### Fase 5 – Polimento Final (Juice)

- Partículas (Neve, explosão de projétil, poeira de pulo e dash).
- Screen Shake e freeze frames nos ataques corpo-a-corpo.
- Sound Design refinado e trilha sonora original.
