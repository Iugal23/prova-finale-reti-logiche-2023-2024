-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_980 is
end project_tb_980;

architecture project_tb_arch_980 of project_tb_980 is
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

constant SCENARIO_LENGTH : integer := 459;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (185,0,45,0,183,0,121,0,114,0,74,0,181,0,6,0,0,0,41,0,0,0,136,0,23,0,97,0,107,0,165,0,236,0,71,0,97,0,254,0,248,0,225,0,169,0,171,0,129,0,113,0,65,0,72,0,131,0,129,0,17,0,195,0,190,0,0,0,0,0,251,0,70,0,237,0,186,0,0,0,0,0,47,0,0,0,0,0,94,0,191,0,166,0,0,0,90,0,34,0,123,0,132,0,63,0,135,0,0,0,129,0,0,0,192,0,130,0,201,0,0,0,56,0,213,0,203,0,104,0,150,0,86,0,0,0,127,0,202,0,254,0,14,0,250,0,67,0,146,0,217,0,81,0,200,0,0,0,100,0,44,0,0,0,0,0,132,0,68,0,161,0,0,0,0,0,98,0,150,0,179,0,57,0,50,0,90,0,0,0,75,0,0,0,52,0,144,0,84,0,79,0,0,0,232,0,0,0,170,0,54,0,60,0,202,0,111,0,0,0,48,0,40,0,80,0,0,0,217,0,202,0,221,0,0,0,159,0,227,0,150,0,0,0,60,0,0,0,109,0,148,0,57,0,2,0,0,0,0,0,91,0,53,0,0,0,209,0,177,0,232,0,172,0,189,0,211,0,116,0,10,0,0,0,73,0,59,0,9,0,225,0,0,0,248,0,113,0,152,0,197,0,109,0,0,0,200,0,255,0,186,0,237,0,30,0,0,0,0,0,111,0,29,0,197,0,190,0,45,0,110,0,0,0,184,0,189,0,112,0,120,0,0,0,115,0,137,0,28,0,0,0,170,0,184,0,25,0,162,0,85,0,0,0,149,0,40,0,133,0,171,0,205,0,108,0,166,0,158,0,253,0,0,0,37,0,66,0,202,0,0,0,231,0,0,0,114,0,146,0,11,0,132,0,0,0,0,0,49,0,194,0,126,0,109,0,0,0,0,0,0,0,205,0,0,0,123,0,130,0,187,0,0,0,57,0,71,0,219,0,220,0,144,0,0,0,189,0,240,0,189,0,0,0,184,0,0,0,55,0,205,0,141,0,124,0,151,0,0,0,32,0,0,0,0,0,129,0,240,0,0,0,203,0,131,0,134,0,0,0,195,0,149,0,78,0,0,0,0,0,145,0,111,0,231,0,183,0,184,0,172,0,35,0,56,0,138,0,44,0,59,0,123,0,200,0,0,0,133,0,139,0,203,0,0,0,169,0,198,0,0,0,0,0,74,0,110,0,0,0,182,0,146,0,219,0,155,0,163,0,145,0,221,0,225,0,142,0,197,0,210,0,12,0,88,0,122,0,148,0,244,0,2,0,0,0,156,0,74,0,105,0,140,0,220,0,8,0,62,0,21,0,0,0,204,0,38,0,78,0,10,0,130,0,147,0,16,0,199,0,204,0,67,0,0,0,22,0,155,0,57,0,0,0,72,0,235,0,0,0,25,0,233,0,143,0,200,0,0,0,0,0,40,0,182,0,47,0,11,0,22,0,39,0,182,0,205,0,109,0,0,0,171,0,0,0,51,0,71,0,230,0,0,0,0,0,155,0,0,0,180,0,0,0,61,0,6,0,0,0,0,0,85,0,232,0,181,0,240,0,141,0,150,0,0,0,0,0,125,0,246,0,0,0,97,0,0,0,0,0,99,0,178,0,121,0,2,0,24,0,0,0,0,0,4,0,241,0,10,0,83,0,41,0,176,0,182,0,0,0,162,0,192,0,9,0,239,0,165,0,168,0,74,0,0,0,0,0,223,0,251,0,132,0,78,0,0,0,61,0,134,0,73,0,39,0,153,0,220,0,236,0,106,0,245,0,0,0,4,0,0,0,224,0,97,0,237,0,137,0,0,0,0,0,32,0,21,0,207,0,34,0,58,0,0,0,203,0,251,0,16,0,0,0,186,0,0,0,136,0,0,0,216,0,19,0,139,0,0,0,242,0,59,0,218,0,172,0,228,0,0,0,0,0,252,0,254,0,0,0,56,0,238,0,73,0,154,0,0,0,0,0,152,0,174,0,43,0,212,0,152,0,192,0,208,0,145,0,151,0,141,0,127,0,195,0,231,0);
signal scenario_full  : scenario_type := (185,31,45,31,183,31,121,31,114,31,74,31,181,31,6,31,6,30,41,31,41,30,136,31,23,31,97,31,107,31,165,31,236,31,71,31,97,31,254,31,248,31,225,31,169,31,171,31,129,31,113,31,65,31,72,31,131,31,129,31,17,31,195,31,190,31,190,30,190,29,251,31,70,31,237,31,186,31,186,30,186,29,47,31,47,30,47,29,94,31,191,31,166,31,166,30,90,31,34,31,123,31,132,31,63,31,135,31,135,30,129,31,129,30,192,31,130,31,201,31,201,30,56,31,213,31,203,31,104,31,150,31,86,31,86,30,127,31,202,31,254,31,14,31,250,31,67,31,146,31,217,31,81,31,200,31,200,30,100,31,44,31,44,30,44,29,132,31,68,31,161,31,161,30,161,29,98,31,150,31,179,31,57,31,50,31,90,31,90,30,75,31,75,30,52,31,144,31,84,31,79,31,79,30,232,31,232,30,170,31,54,31,60,31,202,31,111,31,111,30,48,31,40,31,80,31,80,30,217,31,202,31,221,31,221,30,159,31,227,31,150,31,150,30,60,31,60,30,109,31,148,31,57,31,2,31,2,30,2,29,91,31,53,31,53,30,209,31,177,31,232,31,172,31,189,31,211,31,116,31,10,31,10,30,73,31,59,31,9,31,225,31,225,30,248,31,113,31,152,31,197,31,109,31,109,30,200,31,255,31,186,31,237,31,30,31,30,30,30,29,111,31,29,31,197,31,190,31,45,31,110,31,110,30,184,31,189,31,112,31,120,31,120,30,115,31,137,31,28,31,28,30,170,31,184,31,25,31,162,31,85,31,85,30,149,31,40,31,133,31,171,31,205,31,108,31,166,31,158,31,253,31,253,30,37,31,66,31,202,31,202,30,231,31,231,30,114,31,146,31,11,31,132,31,132,30,132,29,49,31,194,31,126,31,109,31,109,30,109,29,109,28,205,31,205,30,123,31,130,31,187,31,187,30,57,31,71,31,219,31,220,31,144,31,144,30,189,31,240,31,189,31,189,30,184,31,184,30,55,31,205,31,141,31,124,31,151,31,151,30,32,31,32,30,32,29,129,31,240,31,240,30,203,31,131,31,134,31,134,30,195,31,149,31,78,31,78,30,78,29,145,31,111,31,231,31,183,31,184,31,172,31,35,31,56,31,138,31,44,31,59,31,123,31,200,31,200,30,133,31,139,31,203,31,203,30,169,31,198,31,198,30,198,29,74,31,110,31,110,30,182,31,146,31,219,31,155,31,163,31,145,31,221,31,225,31,142,31,197,31,210,31,12,31,88,31,122,31,148,31,244,31,2,31,2,30,156,31,74,31,105,31,140,31,220,31,8,31,62,31,21,31,21,30,204,31,38,31,78,31,10,31,130,31,147,31,16,31,199,31,204,31,67,31,67,30,22,31,155,31,57,31,57,30,72,31,235,31,235,30,25,31,233,31,143,31,200,31,200,30,200,29,40,31,182,31,47,31,11,31,22,31,39,31,182,31,205,31,109,31,109,30,171,31,171,30,51,31,71,31,230,31,230,30,230,29,155,31,155,30,180,31,180,30,61,31,6,31,6,30,6,29,85,31,232,31,181,31,240,31,141,31,150,31,150,30,150,29,125,31,246,31,246,30,97,31,97,30,97,29,99,31,178,31,121,31,2,31,24,31,24,30,24,29,4,31,241,31,10,31,83,31,41,31,176,31,182,31,182,30,162,31,192,31,9,31,239,31,165,31,168,31,74,31,74,30,74,29,223,31,251,31,132,31,78,31,78,30,61,31,134,31,73,31,39,31,153,31,220,31,236,31,106,31,245,31,245,30,4,31,4,30,224,31,97,31,237,31,137,31,137,30,137,29,32,31,21,31,207,31,34,31,58,31,58,30,203,31,251,31,16,31,16,30,186,31,186,30,136,31,136,30,216,31,19,31,139,31,139,30,242,31,59,31,218,31,172,31,228,31,228,30,228,29,252,31,254,31,254,30,56,31,238,31,73,31,154,31,154,30,154,29,152,31,174,31,43,31,212,31,152,31,192,31,208,31,145,31,151,31,141,31,127,31,195,31,231,31);

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
