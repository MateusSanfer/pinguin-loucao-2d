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

O jogador utiliza uma **State Machine modular**, onde cada estado é um nó independente (`Node`) com seu próprio script em `scripts/states/player_states/`. O controlador central (`state_machine.gd`) gerencia as transições entre estados.

Estados implementados:

| Estado        | Script                   | Descrição                                   |
| ------------- | ------------------------ | ------------------------------------------- |
| `Idle`        | `player_idle.gd`         | Parado, aguardando input                    |
| `Walk`        | `player_walk.gd`         | Andando no chão                             |
| `Jump`        | `player_jump.gd`         | Pulando (suporta pulo duplo)                |
| `Fall`        | `player_fall.gd`         | Caindo no ar                                |
| `Duck`        | `player_duck.gd`         | Agachado                                    |
| `Slide`       | `player_slide.gd`        | Deslizando no chão                          |
| `Wall`        | `player_wall.gd`         | Agarrado/deslizando na parede               |
| `Hurt`        | `player_hurt.gd`         | Sofrendo dano (knockback + invencibilidade) |
| `Swimming`    | `player_swimming.gd`     | Nadando na água                             |
| `Attack`      | `player_attack.gd`       | Atacando com projétil (bola de neve)        |
| `MeeleAttack` | `player_meele_attack.gd` | Ataque corpo-a-corpo (martelo)              |

---

## 5. Sistema de Inimigos

O projeto utiliza nós do tipo `Area2D` para hitboxes e detecção.

- **Hitbox da Cabeça:** Vulnerável a pulos do jogador.
- **Hitbox do Corpo:** Causa dano de contato ao jogador se tocado.

**Inimigos Atuais Implementados:**

1. **Esqueleto (Skeleton):** Inimigo básico (Estados: Andar, Atacar, Sofrer Dano).
2. **Minotauro:** Criatura bruta da mitologia grega (representa a quebra das barreiras mitológicas).
3. **Lord Boto:** Inimigo poderoso e sedutor baseado no Boto Cor-de-Rosa (Folclore Brasileiro).
4. **Capuz Vermelho:** Figura encapuzada e misteriosa que aparece em locais secretos dos cenários. Atualmente utiliza o sprite original do Minotauro.

   > **💡 Ideia de Design:** Trocar os nomes internos — o inimigo comum atual (que usa o sprite de "Minotauro") passaria a se chamar **Capuz Vermelho**, e a cena `capuz_vermelho.tscn` passaria a ser o **Minotauro verdadeiro**. Em gameplay, o jogador encontraria um Capuz Vermelho em uma área secreta, e ele se transformaria no Minotauro real como um **mini-boss secreto**, recompensando o jogador com uma habilidade ou item exclusivo ao ser derrotado.

**Inteligência Artificial (IA) Base:**

- Patrulhamento de uma área delimitada.
- Detecção do jogador (Linha de visão ou proximidade via `RayCast2D` / `Area2D`).
- Perseguição e execução de ataque.
  > Adicionar um cooldown para os ataques dos inimigos, como o minotauro e o Lord Boto que atacam muito rápido sem dar chance do jogador de desviar.

---

## 6. Sistema de Chefes (Bosses) - Planejamento

Cada bioma do jogo terá um chefe baseado no folclore brasileiro. Ao derrotá-los, o jogador ganhará uma nova habilidade para acessar áreas antes bloqueadas.
**Possíveis Chefes:**

- **Curupira:** Boss da Floresta Mágica (Desbloqueia o Dash ou outra coisa, a ser decidida).
- **Cuca:** Boss do Pântano (Desbloqueia Magia/Ataques Especiais ou outra coisa, a ser decidida).
- **Iara:** Boss do Igarapé (Desbloqueia a habilidade de paralisar inimigos ou outra coisa, a ser decidida).
- **Boitatá:** Boss de Bioma Vulcânico/Subterrâneo (Desbloqueia resistência ao fogo ou ataque de fogo ou outra coisa, a ser decidida).
- **Boto Cor-de-Rosa(Lord Boto):** Boss do Rio/Caverna (Desbloqueia a habilidade de Nadar ou outra coisa, a ser decidida).
  - **Ataques:**
  - Sopro de água.
  - Corte Oversized(attack_slash_oversize).
  - Corte Reverso(attack_slash_reverse).
  - Ataque de transformação(attack_transform) (O Boto se transforma em um boto gigante e ataca o jogador) (Ainda não implementado e sem animação).
  - Estocada(attack_thrust)
- Minotauro/Depois da transformação do Capuz Vermelho
  - Ataques:
  - Ataque de investida(attack_charge)
  - Ataque de machado(attack_axe)
  - Ataque de martelo(attack_hammer)
  - Ataque de machado e martelo(attack_axe_hammer)
  - Ataque de machado e martelo e investida(attack_axe_hammer_charge)
  - Ataque de machado e investida(attack_axe_charge)
  - Ataque de martelo e investida(attack_hammer_charge)

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

Estrutura atual do projeto, organizada após a refatoração da Fase 2:

```text
res://
├── scenes/
│   ├── characters/
│   │   ├── player/          (player.tscn)
│   │   └── enemies/
│   │       ├── skeleton/     (skeleton.tscn)
│   │       ├── minotaur/     (minotauro.tscn)
│   │       └── lord_boto/    (lord_boto.tscn)
│   ├── levels/               (forest, game, tropic, winter)
│   ├── objects/              (snowball, broken_block, plataformas, etc.)
│   └── ui/                   (menu, opcao, pause_menu, custon_button)
├── scripts/
│   ├── characters/
│   │   ├── player/           (player.gd)
│   │   └── enemies/          (skeleton.gd, minotauro.gd, lord_boto.gd)
│   ├── components/           (health_component, hitbox_component, hurtbox_component)
│   ├── states/
│   │   ├── state_machine.gd
│   │   ├── state.gd
│   │   └── player_states/    (11 scripts de estado individuais)
│   ├── objects/              (camera, snowball, broken_block, etc.)
│   └── ui/                   (health, mana, menu, pause_menu, etc.)
├── Singleton/                (scene_manager.gd)
├── sounds/                   (SFX: jump, ball, click, hover, etc.)
├── sprites/                  (Imagens divididas por personagem e cenário)
├── tiles/                    (TileSets: lava, terrenos, etc.)
└── display/                  (HUD do jogador)
```

---

## Decisões Arquiteturais (Implementadas)

As seguintes decisões de arquitetura foram aplicadas durante a Fase 2 de refatoração:

### Composição via Componentes

O projeto utiliza **Componentes reutilizáveis** em vez de herança para compartilhar comportamentos entre entidades:

- **`HealthComponent`** — Gerencia vida atual/máxima, emite sinais `health_changed`, `damaged` e `died`.
- **`HitboxComponent`** — `Area2D` genérica que recebe dano e repassa ao `HealthComponent` vinculado.
- **`HurtboxComponent`** — `Area2D` genérica que causa dano ao colidir com um `HitboxComponent`.

Para criar um novo inimigo, basta arrastar esses componentes para dentro do nó e conectar os sinais.

### State Machine Modular

O Player utiliza uma **Máquina de Estados** onde cada estado é um **Nó independente** com seu próprio script. Isso eliminou mais de 250 linhas do antigo bloco `match` monolítico em `player.gd`, resultando em código limpo e extensível.

### Singleton (Autoload)

O projeto utiliza um `SceneManager` como Autoload global para gerenciar transições de cena e controle de fluxo do jogo.

---

## Efeitos Sonoros (SFX) Implementados

| Som          | Arquivo            | Evento                         |
| ------------ | ------------------ | ------------------------------ |
| Pulo         | `jump-sound.mp3`   | Ao entrar no estado `Jump`     |
| Bola de Neve | `ball.mp3`         | Ao lançar projétil             |
| Clique (UI)  | `click.wav`        | Ao clicar em botões            |
| Hover (UI)   | `hover.mp3`        | Ao passar o mouse sobre botões |
| Seleção (UI) | `select-sound.mp3` | Ao selecionar opções no menu   |

## 11. Roadmap de Desenvolvimento

### Fase 1 – Protótipo (Concluído / Em Andamento)

- Controle e movimentação fluida do jogador.
- Implementação inicial de inimigos diversos (Esqueleto, Minotauro, Lord Boto).
- Menus estruturados e funcionais (Principal, Opções, Pause).

### Fase 2 – Arquitetura e Componentes

- ✅ Refatorar comportamentos compartilhados (Vida, Dano) usando Componentes (`HealthComponent`, `HitboxComponent`, `HurtboxComponent`).
- ✅ Implementar State Machine modular com 11 estados independentes do Player.
- ✅ Reorganizar estrutura de pastas (`scenes/`, `scripts/`) de forma segura.
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
