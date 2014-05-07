#import "OHMConditionParser.h"
#import <PEGKit/PEGKit.h>


@interface OHMConditionParser ()

@property (nonatomic, retain) NSMutableDictionary *expr_memo;
@property (nonatomic, retain) NSMutableDictionary *negExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *terminalExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *orExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *orTerm_memo;
@property (nonatomic, retain) NSMutableDictionary *andExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *andTerm_memo;
@property (nonatomic, retain) NSMutableDictionary *relExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *relOp_memo;
@property (nonatomic, retain) NSMutableDictionary *relOpTerm_memo;
@property (nonatomic, retain) NSMutableDictionary *callExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *argList_memo;
@property (nonatomic, retain) NSMutableDictionary *primary_memo;
@property (nonatomic, retain) NSMutableDictionary *atom_memo;
@property (nonatomic, retain) NSMutableDictionary *ohmID_memo;
@property (nonatomic, retain) NSMutableDictionary *literal_memo;
@property (nonatomic, retain) NSMutableDictionary *compOp_memo;
@property (nonatomic, retain) NSMutableDictionary *conjOp_memo;
@property (nonatomic, retain) NSMutableDictionary *lt_memo;
@property (nonatomic, retain) NSMutableDictionary *gt_memo;
@property (nonatomic, retain) NSMutableDictionary *eq_memo;
@property (nonatomic, retain) NSMutableDictionary *ne_memo;
@property (nonatomic, retain) NSMutableDictionary *le_memo;
@property (nonatomic, retain) NSMutableDictionary *ge_memo;
@property (nonatomic, retain) NSMutableDictionary *openParen_memo;
@property (nonatomic, retain) NSMutableDictionary *closeParen_memo;
@property (nonatomic, retain) NSMutableDictionary *comma_memo;
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
        self.tokenKindTab[@">="] = @(OHMCONDITIONPARSER_TOKEN_KIND_GE_SYM);
        self.tokenKindTab[@"=="] = @(OHMCONDITIONPARSER_TOKEN_KIND_DOUBLE_EQUALS);
        self.tokenKindTab[@","] = @(OHMCONDITIONPARSER_TOKEN_KIND_COMMA);
        self.tokenKindTab[@"<"] = @(OHMCONDITIONPARSER_TOKEN_KIND_LT_SYM);
        self.tokenKindTab[@"<="] = @(OHMCONDITIONPARSER_TOKEN_KIND_LE_SYM);
        self.tokenKindTab[@"OR"] = @(OHMCONDITIONPARSER_TOKEN_KIND_OR_UPPER);
        self.tokenKindTab[@">"] = @(OHMCONDITIONPARSER_TOKEN_KIND_GT_SYM);
        self.tokenKindTab[@"NOT_DISPLAYED"] = @(OHMCONDITIONPARSER_TOKEN_KIND_NOTDISPLAYED);
        self.tokenKindTab[@"("] = @(OHMCONDITIONPARSER_TOKEN_KIND_OPENPAREN);
        self.tokenKindTab[@"AND"] = @(OHMCONDITIONPARSER_TOKEN_KIND_AND_UPPER);
        self.tokenKindTab[@"!"] = @(OHMCONDITIONPARSER_TOKEN_KIND_BANG);
        self.tokenKindTab[@")"] = @(OHMCONDITIONPARSER_TOKEN_KIND_CLOSEPAREN);
        self.tokenKindTab[@"!="] = @(OHMCONDITIONPARSER_TOKEN_KIND_NOT_EQUAL);
        self.tokenKindTab[@"SKIPPED"] = @(OHMCONDITIONPARSER_TOKEN_KIND_SKIPPED);

        self.tokenKindNameTab[OHMCONDITIONPARSER_TOKEN_KIND_GE_SYM] = @">=";
        self.tokenKindNameTab[OHMCONDITIONPARSER_TOKEN_KIND_DOUBLE_EQUALS] = @"==";
        self.tokenKindNameTab[OHMCONDITIONPARSER_TOKEN_KIND_COMMA] = @",";
        self.tokenKindNameTab[OHMCONDITIONPARSER_TOKEN_KIND_LT_SYM] = @"<";
        self.tokenKindNameTab[OHMCONDITIONPARSER_TOKEN_KIND_LE_SYM] = @"<=";
        self.tokenKindNameTab[OHMCONDITIONPARSER_TOKEN_KIND_OR_UPPER] = @"OR";
        self.tokenKindNameTab[OHMCONDITIONPARSER_TOKEN_KIND_GT_SYM] = @">";
        self.tokenKindNameTab[OHMCONDITIONPARSER_TOKEN_KIND_NOTDISPLAYED] = @"NOT_DISPLAYED";
        self.tokenKindNameTab[OHMCONDITIONPARSER_TOKEN_KIND_OPENPAREN] = @"(";
        self.tokenKindNameTab[OHMCONDITIONPARSER_TOKEN_KIND_AND_UPPER] = @"AND";
        self.tokenKindNameTab[OHMCONDITIONPARSER_TOKEN_KIND_BANG] = @"!";
        self.tokenKindNameTab[OHMCONDITIONPARSER_TOKEN_KIND_CLOSEPAREN] = @")";
        self.tokenKindNameTab[OHMCONDITIONPARSER_TOKEN_KIND_NOT_EQUAL] = @"!=";
        self.tokenKindNameTab[OHMCONDITIONPARSER_TOKEN_KIND_SKIPPED] = @"SKIPPED";

        self.expr_memo = [NSMutableDictionary dictionary];
        self.negExpr_memo = [NSMutableDictionary dictionary];
        self.terminalExpr_memo = [NSMutableDictionary dictionary];
        self.orExpr_memo = [NSMutableDictionary dictionary];
        self.orTerm_memo = [NSMutableDictionary dictionary];
        self.andExpr_memo = [NSMutableDictionary dictionary];
        self.andTerm_memo = [NSMutableDictionary dictionary];
        self.relExpr_memo = [NSMutableDictionary dictionary];
        self.relOp_memo = [NSMutableDictionary dictionary];
        self.relOpTerm_memo = [NSMutableDictionary dictionary];
        self.callExpr_memo = [NSMutableDictionary dictionary];
        self.argList_memo = [NSMutableDictionary dictionary];
        self.primary_memo = [NSMutableDictionary dictionary];
        self.atom_memo = [NSMutableDictionary dictionary];
        self.ohmID_memo = [NSMutableDictionary dictionary];
        self.literal_memo = [NSMutableDictionary dictionary];
        self.compOp_memo = [NSMutableDictionary dictionary];
        self.conjOp_memo = [NSMutableDictionary dictionary];
        self.lt_memo = [NSMutableDictionary dictionary];
        self.gt_memo = [NSMutableDictionary dictionary];
        self.eq_memo = [NSMutableDictionary dictionary];
        self.ne_memo = [NSMutableDictionary dictionary];
        self.le_memo = [NSMutableDictionary dictionary];
        self.ge_memo = [NSMutableDictionary dictionary];
        self.openParen_memo = [NSMutableDictionary dictionary];
        self.closeParen_memo = [NSMutableDictionary dictionary];
        self.comma_memo = [NSMutableDictionary dictionary];
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
    [_terminalExpr_memo removeAllObjects];
    [_orExpr_memo removeAllObjects];
    [_orTerm_memo removeAllObjects];
    [_andExpr_memo removeAllObjects];
    [_andTerm_memo removeAllObjects];
    [_relExpr_memo removeAllObjects];
    [_relOp_memo removeAllObjects];
    [_relOpTerm_memo removeAllObjects];
    [_callExpr_memo removeAllObjects];
    [_argList_memo removeAllObjects];
    [_primary_memo removeAllObjects];
    [_atom_memo removeAllObjects];
    [_ohmID_memo removeAllObjects];
    [_literal_memo removeAllObjects];
    [_compOp_memo removeAllObjects];
    [_conjOp_memo removeAllObjects];
    [_lt_memo removeAllObjects];
    [_gt_memo removeAllObjects];
    [_eq_memo removeAllObjects];
    [_ne_memo removeAllObjects];
    [_le_memo removeAllObjects];
    [_ge_memo removeAllObjects];
    [_openParen_memo removeAllObjects];
    [_closeParen_memo removeAllObjects];
    [_comma_memo removeAllObjects];
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
    if ([self speculate:^{ [self orExpr_]; }]) {
        [self orExpr_]; 
    } else if ([self speculate:^{ [self negExpr_]; }]) {
        [self negExpr_]; 
    } else if ([self speculate:^{ [self terminalExpr_]; }]) {
        [self terminalExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'expr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchExpr:)];
}

- (void)expr_ {
    [self parseRule:@selector(__expr) withMemo:_expr_memo];
}

- (void)__negExpr {
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_BANG discard:YES]; 
    [self orExpr_]; 
    [self execute:^{
    
        NSLog(@"NEGterm: %@", self.assembly);
	BOOL rhs = POP_BOOL();
	PUSH_BOOL(!rhs);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchNegExpr:)];
}

- (void)negExpr_ {
    [self parseRule:@selector(__negExpr) withMemo:_negExpr_memo];
}

- (void)__terminalExpr {
    
    [self atom_]; 
    [self execute:^{
    
	PKToken *tok = [self.assembly pop]; // pop the terminal token
    	 if(tok.isNumber)                      PUSH_BOOL(tok.doubleValue != 0);
	else if(EQ(tok.stringValue, @"NOT_DISPLAYED")) PUSH_BOOL(false);
	else if(EQ(tok.stringValue, @"SKIPPED"))      PUSH_BOOL(false);
	else if(tok.isQuotedString)					PUSH_BOOL(true);


    }];

    [self fireDelegateSelector:@selector(parser:didMatchTerminalExpr:)];
}

- (void)terminalExpr_ {
    [self parseRule:@selector(__terminalExpr) withMemo:_terminalExpr_memo];
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
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_OR_UPPER discard:YES]; 
    [self andExpr_]; 
    [self execute:^{
    
        NSLog(@"ORterm: %@", self.assembly);
	BOOL rhs = POP_BOOL();
	BOOL lhs = POP_BOOL();
	PUSH_BOOL(lhs || rhs);

    }];

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
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_AND_UPPER discard:YES]; 
    [self relExpr_]; 
    [self execute:^{
    
        NSLog(@"ANDterm: %@", self.assembly);
	BOOL rhs = POP_BOOL();
	BOOL lhs = POP_BOOL();
	PUSH_BOOL(lhs && rhs);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchAndTerm:)];
}

- (void)andTerm_ {
    [self parseRule:@selector(__andTerm) withMemo:_andTerm_memo];
}

- (void)__relExpr {
    
    [self callExpr_]; 
    while ([self speculate:^{ [self relOpTerm_]; }]) {
        [self relOpTerm_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchRelExpr:)];
}

- (void)relExpr_ {
    [self parseRule:@selector(__relExpr) withMemo:_relExpr_memo];
}

- (void)__relOp {
    
    if ([self predicts:OHMCONDITIONPARSER_TOKEN_KIND_LT_SYM, 0]) {
        [self match:OHMCONDITIONPARSER_TOKEN_KIND_LT_SYM discard:NO]; 
    } else if ([self predicts:OHMCONDITIONPARSER_TOKEN_KIND_GT_SYM, 0]) {
        [self match:OHMCONDITIONPARSER_TOKEN_KIND_GT_SYM discard:NO]; 
    } else if ([self predicts:OHMCONDITIONPARSER_TOKEN_KIND_DOUBLE_EQUALS, 0]) {
        [self match:OHMCONDITIONPARSER_TOKEN_KIND_DOUBLE_EQUALS discard:NO]; 
    } else if ([self predicts:OHMCONDITIONPARSER_TOKEN_KIND_NOT_EQUAL, 0]) {
        [self match:OHMCONDITIONPARSER_TOKEN_KIND_NOT_EQUAL discard:NO]; 
    } else if ([self predicts:OHMCONDITIONPARSER_TOKEN_KIND_LE_SYM, 0]) {
        [self match:OHMCONDITIONPARSER_TOKEN_KIND_LE_SYM discard:NO]; 
    } else if ([self predicts:OHMCONDITIONPARSER_TOKEN_KIND_GE_SYM, 0]) {
        [self match:OHMCONDITIONPARSER_TOKEN_KIND_GE_SYM discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'relOp'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchRelOp:)];
}

- (void)relOp_ {
    [self parseRule:@selector(__relOp) withMemo:_relOp_memo];
}

- (void)__relOpTerm {
    
    [self relOp_]; 
    [self callExpr_]; 
    [self execute:^{
    
        id rhs = POP();
        NSString  *op = POP_STR();
        id lhs = POP();
        
        BOOL result = NO;
        if ([rhs isKindOfClass:[NSString class]] && [lhs isKindOfClass:[NSString class]]) {
            NSString *rhString = (NSString *)rhs;
            NSString *lhString = (NSString *)lhs;
                 if (EQ(op, @"<"))  result = ([lhString compare:rhString] == NSOrderedAscending);
            else if (EQ(op, @">"))  result = ([lhString compare:rhString] == NSOrderedDescending);
            else if (EQ(op, @"==")) result = [lhString isEqualToString:rhString];
            else if (EQ(op, @"!=")) result = ![lhString isEqualToString:rhString];
            else if (EQ(op, @"<=")) result = ( ([lhString compare:rhString] == NSOrderedAscending)
                                              || ([lhString compare:rhString] == NSOrderedSame) );
            else if (EQ(op, @">=")) result = ( ([lhString compare:rhString] == NSOrderedDescending)
                                              || ([lhString compare:rhString] == NSOrderedSame) );
        }
        else if ([rhs isKindOfClass:[NSNumber class]] && [lhs isKindOfClass:[NSNumber class]]) {
            double rhNumber = ((NSNumber *)rhs).doubleValue;
            double lhNumber = ((NSNumber *)lhs).doubleValue;
                 if (EQ(op, @"<"))  result = (lhNumber <  rhNumber);
            else if (EQ(op, @">"))  result = (lhNumber >  rhNumber);
            else if (EQ(op, @"==")) result = (lhNumber == rhNumber);
            else if (EQ(op, @"!=")) result = (lhNumber != rhNumber);
            else if (EQ(op, @"<=")) result = (lhNumber <= rhNumber);
            else if (EQ(op, @">=")) result = (lhNumber >= rhNumber);
        }
        NSLog(@"lhs: %@, rhs: %@, result: %d", lhs, rhs, result);
        PUSH_BOOL(result);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchRelOpTerm:)];
}

- (void)relOpTerm_ {
    [self parseRule:@selector(__relOpTerm) withMemo:_relOpTerm_memo];
}

- (void)__callExpr {
    
    [self primary_]; 
    if ([self speculate:^{ [self openParen_]; if ([self speculate:^{ [self argList_]; }]) {[self argList_]; }[self closeParen_]; }]) {
        [self openParen_]; 
        if ([self speculate:^{ [self argList_]; }]) {
            [self argList_]; 
        }
        [self closeParen_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchCallExpr:)];
}

- (void)callExpr_ {
    [self parseRule:@selector(__callExpr) withMemo:_callExpr_memo];
}

- (void)__argList {
    
    [self atom_]; 
    while ([self speculate:^{ [self comma_]; [self atom_]; }]) {
        [self comma_]; 
        [self atom_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchArgList:)];
}

- (void)argList_ {
    [self parseRule:@selector(__argList) withMemo:_argList_memo];
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

- (void)__compOp {
    
    if ([self predicts:OHMCONDITIONPARSER_TOKEN_KIND_LT_SYM, 0]) {
        [self lt_]; 
    } else if ([self predicts:OHMCONDITIONPARSER_TOKEN_KIND_GT_SYM, 0]) {
        [self gt_]; 
    } else if ([self predicts:OHMCONDITIONPARSER_TOKEN_KIND_DOUBLE_EQUALS, 0]) {
        [self eq_]; 
    } else if ([self predicts:OHMCONDITIONPARSER_TOKEN_KIND_NOT_EQUAL, 0]) {
        [self ne_]; 
    } else if ([self predicts:OHMCONDITIONPARSER_TOKEN_KIND_LE_SYM, 0]) {
        [self le_]; 
    } else if ([self predicts:OHMCONDITIONPARSER_TOKEN_KIND_GE_SYM, 0]) {
        [self ge_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'compOp'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchCompOp:)];
}

- (void)compOp_ {
    [self parseRule:@selector(__compOp) withMemo:_compOp_memo];
}

- (void)__conjOp {
    
    if ([self predicts:OHMCONDITIONPARSER_TOKEN_KIND_AND_UPPER, 0]) {
        [self and_]; 
    } else if ([self predicts:OHMCONDITIONPARSER_TOKEN_KIND_OR_UPPER, 0]) {
        [self or_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'conjOp'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchConjOp:)];
}

- (void)conjOp_ {
    [self parseRule:@selector(__conjOp) withMemo:_conjOp_memo];
}

- (void)__lt {
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_LT_SYM discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchLt:)];
}

- (void)lt_ {
    [self parseRule:@selector(__lt) withMemo:_lt_memo];
}

- (void)__gt {
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_GT_SYM discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchGt:)];
}

- (void)gt_ {
    [self parseRule:@selector(__gt) withMemo:_gt_memo];
}

- (void)__eq {
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_DOUBLE_EQUALS discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchEq:)];
}

- (void)eq_ {
    [self parseRule:@selector(__eq) withMemo:_eq_memo];
}

- (void)__ne {
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_NOT_EQUAL discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchNe:)];
}

- (void)ne_ {
    [self parseRule:@selector(__ne) withMemo:_ne_memo];
}

- (void)__le {
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_LE_SYM discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchLe:)];
}

- (void)le_ {
    [self parseRule:@selector(__le) withMemo:_le_memo];
}

- (void)__ge {
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_GE_SYM discard:NO]; 

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

- (void)__comma {
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_COMMA discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchComma:)];
}

- (void)comma_ {
    [self parseRule:@selector(__comma) withMemo:_comma_memo];
}

- (void)__or {
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_OR_UPPER discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchOr:)];
}

- (void)or_ {
    [self parseRule:@selector(__or) withMemo:_or_memo];
}

- (void)__and {
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_AND_UPPER discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchAnd:)];
}

- (void)and_ {
    [self parseRule:@selector(__and) withMemo:_and_memo];
}

- (void)__not {
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_BANG discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchNot:)];
}

- (void)not_ {
    [self parseRule:@selector(__not) withMemo:_not_memo];
}

- (void)__notDisplayed {
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_NOTDISPLAYED discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchNotDisplayed:)];
}

- (void)notDisplayed_ {
    [self parseRule:@selector(__notDisplayed) withMemo:_notDisplayed_memo];
}

- (void)__skipped {
    
    [self match:OHMCONDITIONPARSER_TOKEN_KIND_SKIPPED discard:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchSkipped:)];
}

- (void)skipped_ {
    [self parseRule:@selector(__skipped) withMemo:_skipped_memo];
}

@end