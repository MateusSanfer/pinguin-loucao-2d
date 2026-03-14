# 🐧 Projeto de Estudos - Godot 4

Um jogo de plataforma e ação 2D desenvolvido como projeto de estudos para aprofundar os conhecimentos na engine **Godot 4**. O foco do projeto é aprender e implementar mecânicas de gameplay, máquinas de estado (State Machines), manipulação de animações e design de níveis.

## 🎮 Sobre o Jogo

O jogador controla um Pinguim aventureiro que deve explorar cenários perigosos. Para sobreviver, ele conta com um arsenal que inclui o lançamento de bolas de neve à distância e um poderoso ataque corpo a corpo com um martelo para amassar os inimigos!

### ✨ Funcionalidades Atuais

- **Movimentação Fluida:** Pulo, pulo duplo, deslizar (slide), abaixar, wall jump e natação.
- **Sistema de Status:** Barras de Vida (Health) e Mana com regeneração automática.
- **Combate à Distância:** Lançamento de bolas de neve controladas por um `Timer` de recarga.
- **Ataque Especial (Melee):** Um ataque pesado com martelo animado via `AnimationPlayer`, que consome Mana e usa sistema de Pivot para hitboxes precisas.
- **Efeitos Sonoros:** Sons de pulo, ataque, navegação de menus e mais.
- **Inimigos Inteligentes:**
  - **Skeleton:** Patrulha o cenário, detecta paredes/precipícios e lança ossos giratórios ao ver o jogador. Pode ser derrotado pulando em sua cabeça ou com bolas de neve.
  - **Minotauro:** Inimigo mais robusto com áreas de "Agro" (perseguição) e "Attack Range". Possui um ataque de espada sincronizado com a animação e knockback ao levar dano.
  - **Lord Boto:** Boss baseado no Boto Cor-de-Rosa do folclore brasileiro. Possui ataques de espada longa com hitbox ativa apenas no frame de impacto.

### 🧩 Arquitetura do Projeto

- **Componentes Reutilizáveis:** `HealthComponent`, `HitboxComponent` e `HurtboxComponent` — módulos plug-and-play de vida e dano aplicados a todas as entidades.
- **State Machine Modular:** 11 estados independentes do Player (`Idle`, `Walk`, `Jump`, `Fall`, `Duck`, `Slide`, `Wall`, `Hurt`, `Swimming`, `Attack`, `MeeleAttack`), cada um com seu próprio script.
- **Singleton (Autoload):** `SceneManager` para gerenciar transições de cena.

### 🗂️ Estrutura de Pastas

```
res://
├── scenes/
│   ├── characters/       (player, skeleton, minotauro, lord_boto)
│   ├── levels/           (forest, game, tropic, winter)
│   ├── objects/          (snowball, broken_block, plataformas)
│   └── ui/               (menus e botões)
├── scripts/
│   ├── characters/       (scripts dos personagens e inimigos)
│   ├── components/       (health, hitbox, hurtbox)
│   ├── states/           (state_machine + 11 estados do player)
│   ├── objects/          (camera, snowball, etc.)
│   └── ui/               (health bar, mana bar, menus)
├── Singleton/            (SceneManager)
├── sounds/               (SFX)
├── sprites/              (Spritesheets)
└── tiles/                (TileSets)
```

## 🗺️ Etapas de Criação (Roadmap)

### Fase 1: Fundações (Concluído ✅)

- [x] Criar um cenário base (Tilemaps, colisões e áreas letais).
- [x] Adicionar o primeiro personagem (Pinguim).
- [x] Configurar a Máquina de Estados (State Machine) do Player.
- [x] Adicionar sistema de Vida e Mana com UI (ColorRect).

### Fase 2: Combate e Inimigos (Concluído ✅)

- [x] Criar o primeiro inimigo (Skeleton) com IA de patrulha.
- [x] Implementar ataque à distância (Snowball).
- [x] Adicionar o segundo inimigo (Minotauro) com perseguição.
- [x] Implementar ataque corpo a corpo pesado (Martelo) com gasto de mana.
- [x] Refatorar sistema de colisão e Hitboxes (separação de Corpo e Ataque).

### Fase 2.5: Arquitetura e Refatoração (Concluído ✅)

- [x] Criar componentes universais (`HealthComponent`, `HitboxComponent`, `HurtboxComponent`).
- [x] Integrar componentes em todos os inimigos e no Player.
- [x] Implementar State Machine modular com 11 estados independentes do Player.
- [x] Reorganizar estrutura de pastas (`scenes/`, `scripts/`) de forma segura.
- [x] Corrigir lógica de ataque do Lord Boto (hitbox por frame, autodano, morte).
- [x] Adicionar sinal universal `damaged` no `HealthComponent` para knockback.

### Fase 3: Expansão do Mundo (Em Andamento 🚧)

- [ ] Adicionar novos tipos de inimigos com padrões de ataque únicos.
- [ ] Criar quebra-cabeças (Puzzles) pelo cenário (ex: caixas empurráveis, botões, portas).
- [ ] Implementar sistema de itens coletáveis (curas, upgrades).

### Fase 4: O Desafio Final (Futuro 🚀)

- [ ] Desenvolver o primeiro Boss (Chefe) com múltiplas fases de ataque.
- [ ] Criar transições entre diferentes fases/níveis.
- [ ] Polimento visual (Screen shake, partículas de impacto, efeitos sonoros).
- [ ] Exportar o executável final (.exe).

## 📖 Documentação

A documentação completa do jogo (GDD) está disponível em [`penguin_folklore_game_documentation.md`](penguin_folklore_game_documentation.md).

## 🛠️ Tecnologias Utilizadas

- **Engine:** Godot 4.x
- **Linguagem:** GDScript
