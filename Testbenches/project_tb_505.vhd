-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_505 is
end project_tb_505;

architecture project_tb_arch_505 of project_tb_505 is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 545;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (68,0,0,0,8,0,89,0,252,0,76,0,24,0,41,0,170,0,240,0,225,0,159,0,2,0,81,0,122,0,222,0,0,0,135,0,87,0,37,0,51,0,100,0,45,0,219,0,11,0,224,0,5,0,35,0,0,0,214,0,150,0,144,0,158,0,87,0,140,0,87,0,213,0,106,0,167,0,237,0,60,0,5,0,0,0,95,0,186,0,54,0,67,0,193,0,0,0,110,0,0,0,64,0,0,0,95,0,52,0,0,0,199,0,182,0,71,0,150,0,184,0,0,0,42,0,214,0,0,0,35,0,195,0,0,0,14,0,0,0,65,0,34,0,48,0,245,0,42,0,121,0,233,0,166,0,72,0,118,0,51,0,0,0,0,0,164,0,168,0,0,0,0,0,159,0,215,0,0,0,232,0,10,0,26,0,85,0,97,0,35,0,0,0,28,0,54,0,12,0,201,0,113,0,165,0,165,0,155,0,161,0,0,0,26,0,195,0,39,0,0,0,0,0,141,0,112,0,0,0,4,0,187,0,181,0,181,0,59,0,137,0,94,0,79,0,32,0,146,0,138,0,0,0,27,0,0,0,0,0,216,0,242,0,129,0,174,0,0,0,18,0,159,0,192,0,0,0,21,0,0,0,179,0,229,0,245,0,0,0,181,0,44,0,155,0,97,0,205,0,160,0,17,0,222,0,56,0,151,0,181,0,16,0,71,0,198,0,143,0,238,0,27,0,189,0,25,0,72,0,243,0,116,0,85,0,0,0,111,0,248,0,225,0,132,0,0,0,49,0,115,0,38,0,117,0,29,0,236,0,0,0,0,0,50,0,189,0,0,0,52,0,218,0,237,0,238,0,55,0,131,0,31,0,3,0,50,0,0,0,3,0,83,0,131,0,50,0,142,0,73,0,114,0,136,0,115,0,170,0,219,0,5,0,203,0,0,0,200,0,3,0,65,0,115,0,0,0,138,0,0,0,0,0,0,0,70,0,28,0,0,0,6,0,112,0,30,0,68,0,0,0,106,0,42,0,193,0,51,0,118,0,112,0,36,0,121,0,225,0,43,0,157,0,16,0,86,0,180,0,231,0,85,0,255,0,40,0,131,0,122,0,0,0,0,0,155,0,135,0,29,0,212,0,120,0,155,0,164,0,0,0,0,0,56,0,17,0,186,0,8,0,0,0,63,0,138,0,129,0,0,0,169,0,226,0,81,0,156,0,87,0,181,0,126,0,152,0,209,0,235,0,91,0,0,0,87,0,98,0,67,0,32,0,137,0,0,0,114,0,68,0,17,0,242,0,0,0,32,0,210,0,0,0,64,0,189,0,220,0,116,0,187,0,128,0,145,0,0,0,0,0,219,0,108,0,0,0,194,0,222,0,122,0,230,0,252,0,200,0,89,0,37,0,109,0,189,0,14,0,130,0,199,0,205,0,0,0,0,0,37,0,230,0,33,0,243,0,113,0,99,0,118,0,127,0,171,0,160,0,41,0,97,0,12,0,0,0,129,0,66,0,149,0,103,0,0,0,78,0,188,0,44,0,147,0,0,0,159,0,188,0,198,0,217,0,40,0,0,0,22,0,195,0,136,0,129,0,80,0,180,0,246,0,221,0,86,0,60,0,0,0,0,0,171,0,125,0,224,0,182,0,147,0,249,0,241,0,144,0,59,0,213,0,183,0,65,0,155,0,135,0,105,0,99,0,210,0,0,0,0,0,155,0,83,0,255,0,115,0,201,0,0,0,159,0,227,0,171,0,84,0,253,0,0,0,65,0,166,0,0,0,214,0,158,0,0,0,162,0,79,0,253,0,7,0,148,0,0,0,108,0,17,0,231,0,221,0,0,0,219,0,33,0,215,0,0,0,210,0,33,0,57,0,226,0,254,0,0,0,107,0,34,0,85,0,173,0,156,0,0,0,33,0,191,0,229,0,0,0,207,0,119,0,161,0,216,0,24,0,48,0,153,0,67,0,206,0,169,0,192,0,104,0,239,0,184,0,238,0,89,0,0,0,106,0,152,0,17,0,213,0,0,0,159,0,112,0,1,0,21,0,215,0,150,0,216,0,238,0,61,0,0,0,83,0,66,0,76,0,7,0,0,0,0,0,0,0,140,0,245,0,138,0,231,0,76,0,44,0,0,0,244,0,21,0,149,0,224,0,176,0,20,0,62,0,0,0,182,0,45,0,0,0,231,0,0,0,0,0,0,0,50,0,17,0,105,0,52,0,243,0,183,0,61,0,46,0,232,0,0,0,11,0,199,0,166,0,249,0,141,0,12,0,0,0,0,0,130,0,216,0,0,0,0,0,127,0,95,0,39,0,249,0,20,0,141,0,217,0,0,0,0,0,106,0,242,0,119,0,152,0,0,0,148,0,0,0,20,0,255,0,83,0,147,0,2,0,110,0,100,0,7,0,0,0,99,0,0,0,182,0,66,0,167,0,31,0,0,0);
signal scenario_full  : scenario_type := (68,31,68,30,8,31,89,31,252,31,76,31,24,31,41,31,170,31,240,31,225,31,159,31,2,31,81,31,122,31,222,31,222,30,135,31,87,31,37,31,51,31,100,31,45,31,219,31,11,31,224,31,5,31,35,31,35,30,214,31,150,31,144,31,158,31,87,31,140,31,87,31,213,31,106,31,167,31,237,31,60,31,5,31,5,30,95,31,186,31,54,31,67,31,193,31,193,30,110,31,110,30,64,31,64,30,95,31,52,31,52,30,199,31,182,31,71,31,150,31,184,31,184,30,42,31,214,31,214,30,35,31,195,31,195,30,14,31,14,30,65,31,34,31,48,31,245,31,42,31,121,31,233,31,166,31,72,31,118,31,51,31,51,30,51,29,164,31,168,31,168,30,168,29,159,31,215,31,215,30,232,31,10,31,26,31,85,31,97,31,35,31,35,30,28,31,54,31,12,31,201,31,113,31,165,31,165,31,155,31,161,31,161,30,26,31,195,31,39,31,39,30,39,29,141,31,112,31,112,30,4,31,187,31,181,31,181,31,59,31,137,31,94,31,79,31,32,31,146,31,138,31,138,30,27,31,27,30,27,29,216,31,242,31,129,31,174,31,174,30,18,31,159,31,192,31,192,30,21,31,21,30,179,31,229,31,245,31,245,30,181,31,44,31,155,31,97,31,205,31,160,31,17,31,222,31,56,31,151,31,181,31,16,31,71,31,198,31,143,31,238,31,27,31,189,31,25,31,72,31,243,31,116,31,85,31,85,30,111,31,248,31,225,31,132,31,132,30,49,31,115,31,38,31,117,31,29,31,236,31,236,30,236,29,50,31,189,31,189,30,52,31,218,31,237,31,238,31,55,31,131,31,31,31,3,31,50,31,50,30,3,31,83,31,131,31,50,31,142,31,73,31,114,31,136,31,115,31,170,31,219,31,5,31,203,31,203,30,200,31,3,31,65,31,115,31,115,30,138,31,138,30,138,29,138,28,70,31,28,31,28,30,6,31,112,31,30,31,68,31,68,30,106,31,42,31,193,31,51,31,118,31,112,31,36,31,121,31,225,31,43,31,157,31,16,31,86,31,180,31,231,31,85,31,255,31,40,31,131,31,122,31,122,30,122,29,155,31,135,31,29,31,212,31,120,31,155,31,164,31,164,30,164,29,56,31,17,31,186,31,8,31,8,30,63,31,138,31,129,31,129,30,169,31,226,31,81,31,156,31,87,31,181,31,126,31,152,31,209,31,235,31,91,31,91,30,87,31,98,31,67,31,32,31,137,31,137,30,114,31,68,31,17,31,242,31,242,30,32,31,210,31,210,30,64,31,189,31,220,31,116,31,187,31,128,31,145,31,145,30,145,29,219,31,108,31,108,30,194,31,222,31,122,31,230,31,252,31,200,31,89,31,37,31,109,31,189,31,14,31,130,31,199,31,205,31,205,30,205,29,37,31,230,31,33,31,243,31,113,31,99,31,118,31,127,31,171,31,160,31,41,31,97,31,12,31,12,30,129,31,66,31,149,31,103,31,103,30,78,31,188,31,44,31,147,31,147,30,159,31,188,31,198,31,217,31,40,31,40,30,22,31,195,31,136,31,129,31,80,31,180,31,246,31,221,31,86,31,60,31,60,30,60,29,171,31,125,31,224,31,182,31,147,31,249,31,241,31,144,31,59,31,213,31,183,31,65,31,155,31,135,31,105,31,99,31,210,31,210,30,210,29,155,31,83,31,255,31,115,31,201,31,201,30,159,31,227,31,171,31,84,31,253,31,253,30,65,31,166,31,166,30,214,31,158,31,158,30,162,31,79,31,253,31,7,31,148,31,148,30,108,31,17,31,231,31,221,31,221,30,219,31,33,31,215,31,215,30,210,31,33,31,57,31,226,31,254,31,254,30,107,31,34,31,85,31,173,31,156,31,156,30,33,31,191,31,229,31,229,30,207,31,119,31,161,31,216,31,24,31,48,31,153,31,67,31,206,31,169,31,192,31,104,31,239,31,184,31,238,31,89,31,89,30,106,31,152,31,17,31,213,31,213,30,159,31,112,31,1,31,21,31,215,31,150,31,216,31,238,31,61,31,61,30,83,31,66,31,76,31,7,31,7,30,7,29,7,28,140,31,245,31,138,31,231,31,76,31,44,31,44,30,244,31,21,31,149,31,224,31,176,31,20,31,62,31,62,30,182,31,45,31,45,30,231,31,231,30,231,29,231,28,50,31,17,31,105,31,52,31,243,31,183,31,61,31,46,31,232,31,232,30,11,31,199,31,166,31,249,31,141,31,12,31,12,30,12,29,130,31,216,31,216,30,216,29,127,31,95,31,39,31,249,31,20,31,141,31,217,31,217,30,217,29,106,31,242,31,119,31,152,31,152,30,148,31,148,30,20,31,255,31,83,31,147,31,2,31,110,31,100,31,7,31,7,30,99,31,99,30,182,31,66,31,167,31,31,31,31,30);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
