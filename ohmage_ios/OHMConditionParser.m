#import "OHMConditionParser.h"
#import <PEGKit/PEGKit.h>


@interface OHMConditionParser ()

@property (nonatomic, retain) NSMutableDictionary *expr_memo;
@property (nonatomic, retain) NSMutableDictionary *negExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *orExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *orTerm_memo;
@property (nonatomic, retain) NSMutableDictionary *andExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *andTerm_memo;
@property (nonatomic, retain) NSMutableDictionary *relExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *relOpTerm_memo;
@property (nonatomic, retain) NSMutableDictionary *relOp_memo;
@property (nonatomic, retain) NSMutableDictionary *primary_memo;
@property (nonatomic, retain) NSMutableDictionary *atom_memo;
@property (nonatomic, retain) NSMutableDictionary *ohmID_memo;
@property (nonatomic, retain) NSMutableDictionary *literal_memo;
@property (nonatomic, retain) NSMutableDictionary *lt_memo;
@property (nonatomic, retain) NSMutableDictionary *gt_memo;
@property (nonatomic, retain) NSMutableDictionary *eq_memo;
@property (nonatomic, retain) NSMutableDictionary *ne_memo;
@property (nonatomic, retain) NSMutableDictionary *le_memo;
@property (nonatomic, retain) NSMutableDictionary *ge_memo;
@property (nonatomic, retain) NSMutableDictionary *openParen_memo;
@property (nonatomic, retain) NSMutableDictionary *closeParen_memo;
@property (nonatomic, retain) NSMutableDictionary *or_memo;
@property (nonatomic, retain) NSMutableDictionary *and_memo;
@property (nonatomic, retain) NSMutableDictionary *not_memo;
@property (nonatomic, retain) NSMutableDictionary *notDisplayed_memo;
@property (nonatomic, retain) NSMutableDictionary *skipped_memo;
@end

@implementation OHMConditionParser { }

- (id)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"expr";
        self.tokenKindTab[@">="] = @(OHMCONDITIONPARSER_TOKEN_KIND_GE);
        self.tokenKindTab[@"=="] = @(OHMCONDITIONPARSER_TOKEN_KIND_EQ);
        self.tokenKindTab[@"<"] = @(OHMCONDITIONPARSER_TOKEN_KIND_LT);
        self.tokenKindTab[@"<="] = @(OHMCONDITIONPARSER_TOKEN_KIND_LE);
        self.tokenKindTab[@"OR"] = @(OHMCONDITIONPARSER_TOKEN_KIND_OR);
        self.tokenKindTab[@">"] = @(OHMCONDITIONPARSER_TOKEN_KIND_GT);
        self.tokenKindTab[@"NOT_DISPLAYED"] = @(OHMCONDITIONPARSER_TOKEN_KIND_NOTDISPLAYED);
        self.tokenKindTab[@"("] = @(OHMCONDITIONPARSER_TOKEN_KIND_OPENPAREN);
        self.tokenKindTab[@"AND"] = @(OHMCONDITIONPARSER_TOKEN_KIND_AND);
        self.tokenKindTab[@"!"] = @(OHMCONDITIONPARSER_TOKEN_KIND_NOT);
        self.tokenKindTab[@")"] = @(OHMCONDITIONPARSER_TOKEN_KIND_CLOSEPAREN);
        self.tokenKindTab[@"!="] = @(OHMCONDITIONPARSER_TOKEN_KIND_NE);
        self.tokenKindTab[@"SKIPPED"] = @(OHMCONDITIONPARSER_TOKEN_KIND_SKIPPED);

        self.tokenKindNameTab[OHMCONDITIONPARSER_TOKEN_KIND_GE] = @">=";
        self.tokenKindNameTab[OHMCONDITIONPARSER_TOKEN_KIND_EQ] = @"==";
        self.tokenKindNameTab[OHMCONDITIONPARSER_TOKEN_KIND_LT] = @"<";
        self.tokenKindNameTab[OHMCONDITIONPARSER_TOKEN_KIND_LE] = @"<=";
        self.tokenKindNameTab[OHMCONDITIONPARSER_TOKEN_KIND_OR] = @"OR";
        self.tokenKindNameTab[OHMCONDITIONPARSER_TOKEN_KIND_GT] = @">";
        self.tokenKindNameTab[OHMCONDITIONPARSER_TOKEN_KIND_NOTDISPLAYED] = @"NOT_DISPLAYED";
        self.tokenKindNameTab[OHMCONDITIONPARSER_TOKEN_KIND_OPENPAREN] = @"(";
        self.tokenKindNameTab[OHMCONDITIONPARSER_TOKEN_KIND_AND] = @"AND";
        self.tokenKindNameTab[OHMCONDITIONPARSER_TOKEN_KIND_NOT] = @"!";
        self.tokenKindNameTab[OHMCONDITIONPARSER_TOKEN_KIND_CLOSEPAREN] = @")";
        self.tokenKindNameTab[OHMCONDITIONPARSER_TOKEN_KIND_NE] = @"!=";
        self.tokenKindNameTab[OHMCONDITIONPARSER_TOKEN_KIND_SKIPPED] = @"SKIPPED";

        self.expr_memo = [NSMutableDictionary dictionary];
        self.negExpr_memo = [NSMutableDictionary dictionary];
        self.orExpr_memo = [NSMutableDictionary dictionary];
        self.orTerm_memo = [NSMutableDictionary dictionary];
        self.andExpr_memo = [NSMutableDictionary dictionary];
        self.andTerm_memo = [NSMutableDictionary dictionary];
        self.relExpr_memo = [NSMutableDictionary dictionary];
        self.relOpTerm_memo = [NSMutableDictionary dictionary];
        self.relOp_memo = [NSMutableDictionary dictionary];
        self.primary_memo = [NSMutableDictionary dictionary];
        self.atom_memo = [NSMutableDictionary dictionary];
        self.ohmID_memo = [NSMutableDictionary dictionary];
        self.literal_memo = [NSMutableDictionary dictionary];
        self.lt_memo = [NSMutableDictionary dictionary];
        self.gt_memo = [NSMutableDictionary dictionary];
        self.eq_memo = [NSMutableDictionary dictionary];
        self.ne_memo = [NSMutableDictionary dictionary];
        self.le_memo = [NSMutableDictionary dictionary];
        self.ge_memo = [NSMutableDictionary dictionary];
        self.openParen_memo = [NSMutableDictionary dictionary];
        self.closeParen_memo = [NSMutableDictionary dictionary];
        self.or_memo = [NSMutableDictionary dictionary];
        self.and_memo = [NSMutableDictionary dictionary];
        self.not_memo = [NSMutableDictionary dictionary];
        self.notDisplayed_memo = [NSMutableDictionary dictionary];
        self.skipped_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)clearMemo {
    [_expr_memo removeAllObjects];
    [_negExpr_memo removeAllObjects];
    [_orExpr_memo removeAllObjects];
    [_orTerm_memo removeAllObjects];
    [_andExpr_memo removeAllObjects];
    [_andTerm_memo removeAllObjects];
    [_relExpr_memo removeAllObjects];
    [_relOpTerm_memo removeAllObjects];
    [_relOp_memo removeAllObjects];
    [_primary_memo removeAllObjects];
    [_atom_memo removeAllObjects];
    [_ohmID_memo removeAllObjects];
    [_literal_memo removeAllObjects];
    [_lt_memo removeAllObjects];
    [_gt_memo removeAllObjects];
    [_eq_memo removeAllObjects];
    [_ne_memo removeAllObjects];
    [_le_memo removeAllObjects];
    [_ge_memo removeAllObjects];
    [_openParen_memo removeAllObjects];
    [_closeParen_memo removeAllObjects];
    [_or_memo removeAllObjects];
    [_and_memo removeAllObjects];
    [_not_memo removeAllObjects];
    [_notDisplayed_memo removeAllObjects];
    [_skipped_memo removeAllObjects];
}

- (void)start {

    [self expr_]; 
    [self matchEOF:YES]; 

}

- (void)__expr {
    
    [self execute:^{
    
    PKTokenizer *t = self.tokenizer;
    [t.symbolState add:@"!="];
    [t.symbolState add:@"<="];
    [t.symbolState add:@">="];

    }];
    if ([self predicts:OHMCONDITIONPARSER_TOKEN_KIND_NOTDISPLAYED, OHMCONDITIONPARSER_TOKEN_KIND_OPENPAREN, OHMCONDITIONPARSER_TOKEN_KIND_SKIPPED, TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self orExpr_]; 
    } else if ([self predicts:OHMCONDITIONPARSER_TOKEN_KIND_NOT, 0]) {
        [self negExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'expr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchExpr:)];
}

- (void)expr_ {
    [self parseRule:@selector(__expr) withMemo:_expr_memo];
}

- (void)__negExpr {
    
    [self not_]; 
    [self orExpr_]; 
    [self execute:^{
    
	BOOL rhs = POP_BOOL();
	PUSH_BOOL(!rhs);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchNegExpr:)];
}

- (void)negExpr_ {
    [self parseRule:@selector(__negExpr) withMemo:_negExpr_memo];
}

- (void)__orExpr {
    
    [self andExpr_]; 
    while ([self speculate:^{ [self orTerm_]; }]) {
        [self orTerm_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchOrExpr:)];
}

- (void)orExpr_ {
    [self parseRule:@selector(__orExpr) withMemo:_orExpr_memo];
}

- (void)__orTerm {
    
    [self or_]; 
    [self andExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchOrTerm:)];
}

- (void)orTerm_ {
    [self parseRule:@selector(__orTerm) withMemo:_orTerm_memo];
}

- (void)__andExpr {
    
    [self relExpr_]; 
    while ([self speculate:^{ [self andTerm_]; }]) {
        [self andTerm_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchAndExpr:)];
}

- (void)andExpr_ {
    [self parseRule:@selector(__andExpr) withMemo:_andExpr_memo];
}

- (void)__andTerm {
    
    [self and_]; 
    [self relExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchAndTerm:)];
}

- (void)andTerm_ {
    [self parseRule:@selector(__andTerm) withMemo:_andTerm_memo];
}

- (void)__relExpr {
    
    [self primary_]; 
    while ([self speculate:^{ [self relOpTerm_]; }]) {
        [self relOpTerm_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchRelExpr:)];
}

- (void)relExpr_ {
    [self parseRule:@selector(__relExpr) withMemo:_relExpr_memo];
}

- (void)__relOpTerm {
    
    [self relOp_]; 
    [self primary_]; 

    [self fireDelegateSelector:@selector(parser:didMatchRelOpTerm:)];
}

- (void)relOpTerm_ {
    [self parseRule:@selector(__relOpTerm) withMemo:_relOpTerm_memo];
}

- (void)__relOp {
    
    if ([self predicts:OHMCONDITIONPARSER_TOKEN_KIND_LT, 0]) {
        [self lt_]; 
    } else if ([self predicts:OHMCONDITIONPARSER_TOKEN_KIND_GT, 0]) {
        [self gt_]; 
    } else if ([self predicts:OHMCONDITIONPARSER_TOKEN_KIND_EQ, 0]) {
        [self eq_]; 
    } else if ([self predicts:OHMCONDITIONPARSER_TOKEN_KIND_NE, 0]) {
        [self ne_]; 
    } else if ([self predicts:OHMCONDITIONPARSER_TOKEN_KIND_LE, 0]) {
        [self le_]; 
    } else if ([self predicts:OHMCONDITIONPARSER_TOKEN_KIND_GE, 0]) {
        [self ge_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'relOp'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchRelOp:)];
}

- (void)relOp_ {
    [self parseRule:@selector(__relOp) withMemo:_relOp_memo];
}

- (void)__primary {
    
    if ([self predicts:OHMCONDITIONPARSER_TOKEN_KIND_NOTDISPLAYED, OHMCONDITIONPARSER_TOKEN_KIND_SKIPPED, TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self atom_]; 
    } else if ([self predicts:OHMCONDITIONPARSER_TOKEN_KIND_OPENPAREN, 0]) {
        [self openParen_]; 
        [self expr_]; 
        [self closeParen_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'primary'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPrimary:)];
}

- (void)primary_ {
    [self parseRule:@selector(__primary) withMemo:_primary_memo];
}

- (void)__atom {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self ohmID_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self literal_]; 
    } else if ([self predicts:OHMCONDITIONPARSER_TOKEN_KIND_SKIPPED, 0]) {
        [self skipped_]; 
    } else if ([self predicts:OHMCONDITIONPARSER_TOKEN_KIND_NOTDISPLAYED, 0]) {
        [self notDisplayed_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'atom'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAtom:)];
}

- (void)atom_ {
    [self parseRule:@selector(__atom) withMemo:_atom_memo];
}

- (void)__ohmID {
    
    [self matchWord:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchOhmID:)];
}

- (void)ohmID_ {
    [self parseRule:@selector(__ohmID) withMemo:_ohmID_memo];
}

- (void)__literal {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self matchNumber:NO]; 
        [self execute:^{
         PUSH_FLOAT(POP_FLOAT()); 
        }];
    } else if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self matchQuotedString:NO]; 
        [self execute:^{
         PUSH(POP_QUOTED_STR()); 
        }];
    } else {
        [self raise:@"No viable alternative found in rule 'literal'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchLiteral:)];
}

- (void)literal_ {
    [self parseRule:@selector(__literal) withMemo:_literal_memo];
}

- (void)__lt {
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_LT discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchLt:)];
}

- (void)lt_ {
    [self parseRule:@selector(__lt) withMemo:_lt_memo];
}

- (void)__gt {
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_GT discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchGt:)];
}

- (void)gt_ {
    [self parseRule:@selector(__gt) withMemo:_gt_memo];
}

- (void)__eq {
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_EQ discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchEq:)];
}

- (void)eq_ {
    [self parseRule:@selector(__eq) withMemo:_eq_memo];
}

- (void)__ne {
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_NE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchNe:)];
}

- (void)ne_ {
    [self parseRule:@selector(__ne) withMemo:_ne_memo];
}

- (void)__le {
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_LE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchLe:)];
}

- (void)le_ {
    [self parseRule:@selector(__le) withMemo:_le_memo];
}

- (void)__ge {
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_GE discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchGe:)];
}

- (void)ge_ {
    [self parseRule:@selector(__ge) withMemo:_ge_memo];
}

- (void)__openParen {
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_OPENPAREN discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchOpenParen:)];
}

- (void)openParen_ {
    [self parseRule:@selector(__openParen) withMemo:_openParen_memo];
}

- (void)__closeParen {
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_CLOSEPAREN discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchCloseParen:)];
}

- (void)closeParen_ {
    [self parseRule:@selector(__closeParen) withMemo:_closeParen_memo];
}

- (void)__or {
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_OR discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchOr:)];
}

- (void)or_ {
    [self parseRule:@selector(__or) withMemo:_or_memo];
}

- (void)__and {
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_AND discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchAnd:)];
}

- (void)and_ {
    [self parseRule:@selector(__and) withMemo:_and_memo];
}

- (void)__not {
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_NOT discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchNot:)];
}

- (void)not_ {
    [self parseRule:@selector(__not) withMemo:_not_memo];
}

- (void)__notDisplayed {
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_NOTDISPLAYED discard:NO]; 
    [self execute:^{
     PUSH(POP_STR()); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchNotDisplayed:)];
}

- (void)notDisplayed_ {
    [self parseRule:@selector(__notDisplayed) withMemo:_notDisplayed_memo];
}

- (void)__skipped {
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_SKIPPED discard:NO]; 
    [self execute:^{
     PUSH(POP_STR()); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchSkipped:)];
}

- (void)skipped_ {
    [self parseRule:@selector(__skipped) withMemo:_skipped_memo];
}

@end