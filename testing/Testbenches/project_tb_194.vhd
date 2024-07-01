-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_194 is
end project_tb_194;

architecture project_tb_arch_194 of project_tb_194 is
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

constant SCENARIO_LENGTH : integer := 579;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (164,0,18,0,48,0,0,0,101,0,92,0,225,0,99,0,153,0,189,0,194,0,3,0,154,0,4,0,87,0,0,0,228,0,103,0,51,0,183,0,7,0,2,0,86,0,172,0,26,0,8,0,61,0,24,0,27,0,196,0,85,0,0,0,138,0,230,0,215,0,0,0,10,0,103,0,156,0,141,0,0,0,125,0,0,0,217,0,33,0,173,0,46,0,0,0,17,0,254,0,0,0,252,0,169,0,0,0,0,0,205,0,24,0,75,0,0,0,231,0,71,0,0,0,119,0,189,0,180,0,0,0,0,0,209,0,0,0,28,0,36,0,98,0,153,0,0,0,234,0,24,0,81,0,104,0,143,0,173,0,238,0,128,0,0,0,126,0,202,0,34,0,0,0,11,0,163,0,160,0,233,0,177,0,47,0,77,0,32,0,39,0,226,0,0,0,152,0,48,0,0,0,108,0,0,0,0,0,63,0,225,0,59,0,43,0,5,0,109,0,142,0,27,0,0,0,239,0,204,0,208,0,72,0,0,0,0,0,168,0,34,0,199,0,0,0,68,0,10,0,22,0,0,0,39,0,0,0,42,0,106,0,191,0,71,0,0,0,0,0,232,0,0,0,53,0,90,0,159,0,21,0,0,0,224,0,112,0,237,0,190,0,118,0,0,0,0,0,176,0,41,0,231,0,96,0,106,0,133,0,166,0,160,0,89,0,252,0,114,0,192,0,235,0,208,0,82,0,147,0,250,0,115,0,49,0,118,0,0,0,143,0,250,0,161,0,78,0,29,0,101,0,0,0,0,0,9,0,231,0,0,0,156,0,0,0,94,0,12,0,123,0,0,0,72,0,163,0,234,0,168,0,0,0,190,0,242,0,137,0,0,0,229,0,0,0,0,0,195,0,38,0,125,0,0,0,38,0,253,0,0,0,90,0,73,0,152,0,7,0,32,0,0,0,212,0,192,0,88,0,198,0,103,0,253,0,112,0,173,0,0,0,0,0,30,0,231,0,12,0,209,0,142,0,125,0,0,0,119,0,66,0,123,0,30,0,0,0,114,0,131,0,190,0,132,0,193,0,54,0,166,0,127,0,140,0,156,0,247,0,206,0,0,0,123,0,228,0,103,0,0,0,43,0,69,0,0,0,0,0,75,0,10,0,13,0,85,0,200,0,207,0,248,0,10,0,49,0,76,0,0,0,249,0,43,0,0,0,73,0,34,0,236,0,99,0,212,0,221,0,185,0,0,0,118,0,18,0,0,0,146,0,0,0,137,0,207,0,140,0,156,0,217,0,89,0,19,0,175,0,0,0,166,0,216,0,28,0,175,0,234,0,203,0,185,0,0,0,178,0,131,0,172,0,81,0,0,0,207,0,227,0,236,0,91,0,224,0,22,0,13,0,107,0,1,0,61,0,0,0,0,0,62,0,75,0,163,0,160,0,83,0,231,0,0,0,20,0,1,0,169,0,30,0,0,0,237,0,21,0,136,0,212,0,104,0,133,0,26,0,0,0,235,0,170,0,23,0,211,0,131,0,10,0,0,0,75,0,0,0,11,0,0,0,248,0,2,0,0,0,135,0,0,0,30,0,0,0,233,0,116,0,99,0,46,0,9,0,0,0,0,0,135,0,179,0,83,0,0,0,27,0,25,0,158,0,61,0,154,0,219,0,89,0,0,0,89,0,0,0,0,0,185,0,196,0,0,0,65,0,0,0,168,0,125,0,250,0,5,0,23,0,215,0,170,0,22,0,25,0,190,0,22,0,77,0,0,0,0,0,13,0,0,0,150,0,191,0,160,0,241,0,76,0,12,0,168,0,153,0,210,0,213,0,0,0,0,0,163,0,69,0,160,0,108,0,166,0,224,0,151,0,0,0,67,0,0,0,115,0,176,0,184,0,0,0,67,0,100,0,100,0,181,0,0,0,195,0,175,0,229,0,151,0,0,0,58,0,132,0,29,0,95,0,145,0,179,0,121,0,0,0,166,0,67,0,54,0,101,0,216,0,64,0,225,0,104,0,98,0,0,0,0,0,230,0,222,0,52,0,0,0,225,0,193,0,65,0,44,0,121,0,216,0,0,0,95,0,225,0,0,0,0,0,77,0,61,0,0,0,124,0,0,0,47,0,64,0,38,0,127,0,66,0,205,0,172,0,37,0,197,0,0,0,0,0,50,0,33,0,26,0,175,0,159,0,0,0,199,0,0,0,214,0,12,0,0,0,31,0,3,0,172,0,0,0,159,0,29,0,0,0,96,0,88,0,16,0,235,0,127,0,185,0,0,0,172,0,0,0,212,0,214,0,59,0,87,0,121,0,0,0,0,0,221,0,0,0,0,0,49,0,242,0,231,0,0,0,35,0,0,0,5,0,211,0,34,0,0,0,44,0,73,0,156,0,144,0,213,0,111,0,56,0,0,0,225,0,140,0,158,0,0,0,104,0,146,0,41,0,0,0,0,0,225,0,194,0,0,0,246,0,129,0,0,0,181,0,81,0,191,0,250,0,159,0,182,0,157,0,70,0,0,0,243,0,186,0,248,0,79,0,99,0,198,0,38,0,208,0,161,0,164,0,97,0,0,0,228,0,112,0,95,0,7,0,155,0);
signal scenario_full  : scenario_type := (164,31,18,31,48,31,48,30,101,31,92,31,225,31,99,31,153,31,189,31,194,31,3,31,154,31,4,31,87,31,87,30,228,31,103,31,51,31,183,31,7,31,2,31,86,31,172,31,26,31,8,31,61,31,24,31,27,31,196,31,85,31,85,30,138,31,230,31,215,31,215,30,10,31,103,31,156,31,141,31,141,30,125,31,125,30,217,31,33,31,173,31,46,31,46,30,17,31,254,31,254,30,252,31,169,31,169,30,169,29,205,31,24,31,75,31,75,30,231,31,71,31,71,30,119,31,189,31,180,31,180,30,180,29,209,31,209,30,28,31,36,31,98,31,153,31,153,30,234,31,24,31,81,31,104,31,143,31,173,31,238,31,128,31,128,30,126,31,202,31,34,31,34,30,11,31,163,31,160,31,233,31,177,31,47,31,77,31,32,31,39,31,226,31,226,30,152,31,48,31,48,30,108,31,108,30,108,29,63,31,225,31,59,31,43,31,5,31,109,31,142,31,27,31,27,30,239,31,204,31,208,31,72,31,72,30,72,29,168,31,34,31,199,31,199,30,68,31,10,31,22,31,22,30,39,31,39,30,42,31,106,31,191,31,71,31,71,30,71,29,232,31,232,30,53,31,90,31,159,31,21,31,21,30,224,31,112,31,237,31,190,31,118,31,118,30,118,29,176,31,41,31,231,31,96,31,106,31,133,31,166,31,160,31,89,31,252,31,114,31,192,31,235,31,208,31,82,31,147,31,250,31,115,31,49,31,118,31,118,30,143,31,250,31,161,31,78,31,29,31,101,31,101,30,101,29,9,31,231,31,231,30,156,31,156,30,94,31,12,31,123,31,123,30,72,31,163,31,234,31,168,31,168,30,190,31,242,31,137,31,137,30,229,31,229,30,229,29,195,31,38,31,125,31,125,30,38,31,253,31,253,30,90,31,73,31,152,31,7,31,32,31,32,30,212,31,192,31,88,31,198,31,103,31,253,31,112,31,173,31,173,30,173,29,30,31,231,31,12,31,209,31,142,31,125,31,125,30,119,31,66,31,123,31,30,31,30,30,114,31,131,31,190,31,132,31,193,31,54,31,166,31,127,31,140,31,156,31,247,31,206,31,206,30,123,31,228,31,103,31,103,30,43,31,69,31,69,30,69,29,75,31,10,31,13,31,85,31,200,31,207,31,248,31,10,31,49,31,76,31,76,30,249,31,43,31,43,30,73,31,34,31,236,31,99,31,212,31,221,31,185,31,185,30,118,31,18,31,18,30,146,31,146,30,137,31,207,31,140,31,156,31,217,31,89,31,19,31,175,31,175,30,166,31,216,31,28,31,175,31,234,31,203,31,185,31,185,30,178,31,131,31,172,31,81,31,81,30,207,31,227,31,236,31,91,31,224,31,22,31,13,31,107,31,1,31,61,31,61,30,61,29,62,31,75,31,163,31,160,31,83,31,231,31,231,30,20,31,1,31,169,31,30,31,30,30,237,31,21,31,136,31,212,31,104,31,133,31,26,31,26,30,235,31,170,31,23,31,211,31,131,31,10,31,10,30,75,31,75,30,11,31,11,30,248,31,2,31,2,30,135,31,135,30,30,31,30,30,233,31,116,31,99,31,46,31,9,31,9,30,9,29,135,31,179,31,83,31,83,30,27,31,25,31,158,31,61,31,154,31,219,31,89,31,89,30,89,31,89,30,89,29,185,31,196,31,196,30,65,31,65,30,168,31,125,31,250,31,5,31,23,31,215,31,170,31,22,31,25,31,190,31,22,31,77,31,77,30,77,29,13,31,13,30,150,31,191,31,160,31,241,31,76,31,12,31,168,31,153,31,210,31,213,31,213,30,213,29,163,31,69,31,160,31,108,31,166,31,224,31,151,31,151,30,67,31,67,30,115,31,176,31,184,31,184,30,67,31,100,31,100,31,181,31,181,30,195,31,175,31,229,31,151,31,151,30,58,31,132,31,29,31,95,31,145,31,179,31,121,31,121,30,166,31,67,31,54,31,101,31,216,31,64,31,225,31,104,31,98,31,98,30,98,29,230,31,222,31,52,31,52,30,225,31,193,31,65,31,44,31,121,31,216,31,216,30,95,31,225,31,225,30,225,29,77,31,61,31,61,30,124,31,124,30,47,31,64,31,38,31,127,31,66,31,205,31,172,31,37,31,197,31,197,30,197,29,50,31,33,31,26,31,175,31,159,31,159,30,199,31,199,30,214,31,12,31,12,30,31,31,3,31,172,31,172,30,159,31,29,31,29,30,96,31,88,31,16,31,235,31,127,31,185,31,185,30,172,31,172,30,212,31,214,31,59,31,87,31,121,31,121,30,121,29,221,31,221,30,221,29,49,31,242,31,231,31,231,30,35,31,35,30,5,31,211,31,34,31,34,30,44,31,73,31,156,31,144,31,213,31,111,31,56,31,56,30,225,31,140,31,158,31,158,30,104,31,146,31,41,31,41,30,41,29,225,31,194,31,194,30,246,31,129,31,129,30,181,31,81,31,191,31,250,31,159,31,182,31,157,31,70,31,70,30,243,31,186,31,248,31,79,31,99,31,198,31,38,31,208,31,161,31,164,31,97,31,97,30,228,31,112,31,95,31,7,31,155,31);

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
