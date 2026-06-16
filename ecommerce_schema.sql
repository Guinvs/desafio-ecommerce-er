-- ============================================
-- ESQUEMA E-COMMERCE - MySQL Workbench
-- ============================================

CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- ============================================
-- TABELA: CLIENTE (supertipo)
-- ============================================
CREATE TABLE cliente (
    id_cliente INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    tipo_pessoa ENUM('PF', 'PJ') NOT NULL,
    PRIMARY KEY (id_cliente)
);

-- ============================================
-- TABELA: CLIENTE_PF (subtipo)
-- ============================================
CREATE TABLE cliente_pf (
    id_cliente INT NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE,
    PRIMARY KEY (id_cliente),
    CONSTRAINT fk_clientepf_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente)
        ON DELETE CASCADE
);

-- ============================================
-- TABELA: CLIENTE_PJ (subtipo)
-- ============================================
CREATE TABLE cliente_pj (
    id_cliente INT NOT NULL,
    cnpj VARCHAR(14) NOT NULL UNIQUE,
    razao_social VARCHAR(150) NOT NULL,
    inscricao_estadual VARCHAR(20),
    PRIMARY KEY (id_cliente),
    CONSTRAINT fk_clientepj_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente)
        ON DELETE CASCADE
);

-- ============================================
-- TABELA: ENDERECO
-- ============================================
CREATE TABLE endereco (
    id_endereco INT NOT NULL AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    logradouro VARCHAR(150) NOT NULL,
    numero VARCHAR(10),
    complemento VARCHAR(50),
    bairro VARCHAR(80),
    cidade VARCHAR(80) NOT NULL,
    estado CHAR(2) NOT NULL,
    cep VARCHAR(9) NOT NULL,
    tipo_endereco ENUM('ENTREGA', 'COBRANCA') NOT NULL DEFAULT 'ENTREGA',
    PRIMARY KEY (id_endereco),
    CONSTRAINT fk_endereco_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente)
        ON DELETE CASCADE
);

-- ============================================
-- TABELA: CATEGORIA
-- ============================================
CREATE TABLE categoria (
    id_categoria INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    PRIMARY KEY (id_categoria)
);

-- ============================================
-- TABELA: PRODUTO
-- ============================================
CREATE TABLE produto (
    id_produto INT NOT NULL AUTO_INCREMENT,
    id_categoria INT NOT NULL,
    nome VARCHAR(150) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL,
    estoque INT NOT NULL DEFAULT 0,
    PRIMARY KEY (id_produto),
    CONSTRAINT fk_produto_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES categoria (id_categoria)
        ON DELETE RESTRICT
);

-- ============================================
-- TABELA: PEDIDO
-- ============================================
CREATE TABLE pedido (
    id_pedido INT NOT NULL AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    data_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status_pedido ENUM('AGUARDANDO_PAGAMENTO','PROCESSANDO','ENVIADO','ENTREGUE','CANCELADO') NOT NULL DEFAULT 'AGUARDANDO_PAGAMENTO',
    valor_total DECIMAL(10,2) NOT NULL DEFAULT 0,
    PRIMARY KEY (id_pedido),
    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente)
        ON DELETE RESTRICT
);

-- ============================================
-- TABELA: ITEM_PEDIDO (associativa N:N)
-- ============================================
CREATE TABLE item_pedido (
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL DEFAULT 1,
    preco_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_pedido, id_produto),
    CONSTRAINT fk_itempedido_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES pedido (id_pedido)
        ON DELETE CASCADE,
    CONSTRAINT fk_itempedido_produto
        FOREIGN KEY (id_produto)
        REFERENCES produto (id_produto)
        ON DELETE RESTRICT
);

-- ============================================
-- TABELA: PAGAMENTO (1 pedido pode ter N pagamentos)
-- ============================================
CREATE TABLE pagamento (
    id_pagamento INT NOT NULL AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    forma_pagamento ENUM('CARTAO_CREDITO','CARTAO_DEBITO','BOLETO','PIX') NOT NULL,
    status_pagamento ENUM('PENDENTE','APROVADO','RECUSADO','REEMBOLSADO') NOT NULL DEFAULT 'PENDENTE',
    valor DECIMAL(10,2) NOT NULL,
    data_pagamento DATETIME,
    PRIMARY KEY (id_pagamento),
    CONSTRAINT fk_pagamento_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES pedido (id_pedido)
        ON DELETE CASCADE
);

-- ============================================
-- TABELA: ENTREGA (1:1 com pedido)
-- ============================================
CREATE TABLE entrega (
    id_entrega INT NOT NULL AUTO_INCREMENT,
    id_pedido INT NOT NULL UNIQUE,
    status_entrega ENUM('AGUARDANDO','EM_TRANSITO','ENTREGUE','DEVOLVIDO') NOT NULL DEFAULT 'AGUARDANDO',
    codigo_rastreio VARCHAR(50),
    transportadora VARCHAR(100),
    data_envio DATETIME,
    data_entrega_prevista DATE,
    PRIMARY KEY (id_entrega),
    CONSTRAINT fk_entrega_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES pedido (id_pedido)
        ON DELETE CASCADE
);
