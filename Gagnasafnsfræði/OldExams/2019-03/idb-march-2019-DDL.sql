-- The 1..N requirement for Child in Cures is not represented in the database

CREATE TABLE Doctor (
    DID SERIAL PRIMARY KEY,
    Dname NOT NULL VARCHAR(50)
);

CREATE TABLE Child (
    CID SERIAL PRIMARY KEY,
    Cname NOT NULL VARCHAR(50)
);
    
CREATE TABLE QualityAssurer (
    QAID SERIAL PRIMARY KEY,
    QAname NOT NULL VARCHAR(50)
);

CREATE TABLE LegalGuardian (
    CID INTEGER REFERENCES Child(CID),
    LGname VARCHAR(50),
    PRIMARY KEY (CID, LGname)
);

CREATE TABLE Cures (
    DID INTEGER REFERENCES Doctor(DID),
    CID INTEGER REFERENCES Child(CID),
    since NOT NULL DATE,
    PRIMARY KEY (DID, CID)
);

CREATE TABLE Monitors (
    QAID INTEGER REFERENCES QualityAssurer(QAID),
    DID INTEGER,
    CID INTEGER,
    grade NOT NULL INTEGER,
    PRIMARY KEY (DID, CID, QAID),
    FOREIGN KEY (DID, CID) REFERENCES Cures(DID, CID)
);


    

    
