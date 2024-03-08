-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_177 is
end project_tb_177;

architecture project_tb_arch_177 of project_tb_177 is
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

constant SCENARIO_LENGTH : integer := 424;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (153,0,239,0,110,0,193,0,0,0,0,0,166,0,0,0,73,0,0,0,17,0,118,0,96,0,21,0,0,0,130,0,172,0,155,0,204,0,1,0,253,0,79,0,252,0,15,0,125,0,0,0,39,0,27,0,0,0,58,0,144,0,0,0,122,0,0,0,0,0,121,0,122,0,42,0,29,0,22,0,125,0,143,0,143,0,182,0,0,0,193,0,0,0,176,0,0,0,113,0,92,0,85,0,132,0,4,0,86,0,122,0,143,0,0,0,40,0,50,0,58,0,217,0,66,0,182,0,24,0,207,0,111,0,47,0,180,0,0,0,177,0,26,0,245,0,42,0,247,0,0,0,36,0,0,0,206,0,236,0,104,0,97,0,0,0,150,0,224,0,183,0,139,0,72,0,20,0,192,0,0,0,0,0,126,0,30,0,73,0,200,0,207,0,124,0,18,0,0,0,40,0,227,0,112,0,30,0,38,0,63,0,172,0,205,0,8,0,181,0,154,0,12,0,153,0,0,0,34,0,212,0,253,0,225,0,180,0,173,0,66,0,0,0,23,0,48,0,148,0,175,0,169,0,158,0,110,0,164,0,226,0,174,0,214,0,115,0,0,0,68,0,0,0,0,0,81,0,138,0,0,0,138,0,217,0,247,0,0,0,0,0,209,0,15,0,114,0,11,0,158,0,250,0,29,0,112,0,8,0,0,0,0,0,148,0,0,0,19,0,194,0,106,0,101,0,3,0,67,0,152,0,183,0,239,0,126,0,213,0,0,0,0,0,147,0,0,0,157,0,0,0,0,0,154,0,125,0,0,0,138,0,73,0,0,0,34,0,112,0,109,0,164,0,69,0,252,0,212,0,204,0,103,0,196,0,0,0,0,0,0,0,91,0,95,0,254,0,0,0,190,0,224,0,145,0,49,0,0,0,165,0,131,0,102,0,0,0,232,0,173,0,0,0,0,0,17,0,166,0,167,0,194,0,37,0,204,0,30,0,174,0,141,0,176,0,178,0,34,0,4,0,89,0,0,0,178,0,223,0,231,0,233,0,101,0,137,0,216,0,45,0,220,0,78,0,89,0,0,0,210,0,102,0,44,0,203,0,215,0,0,0,10,0,87,0,208,0,0,0,4,0,150,0,0,0,152,0,81,0,10,0,0,0,80,0,129,0,0,0,0,0,0,0,166,0,59,0,0,0,37,0,183,0,76,0,32,0,0,0,164,0,43,0,0,0,234,0,0,0,81,0,43,0,0,0,220,0,33,0,25,0,215,0,0,0,255,0,212,0,222,0,0,0,0,0,4,0,85,0,104,0,0,0,37,0,0,0,132,0,216,0,85,0,4,0,114,0,143,0,53,0,108,0,49,0,0,0,205,0,143,0,183,0,49,0,114,0,211,0,56,0,230,0,60,0,161,0,248,0,194,0,0,0,12,0,135,0,145,0,95,0,5,0,110,0,0,0,0,0,129,0,244,0,160,0,12,0,97,0,108,0,131,0,106,0,203,0,63,0,0,0,67,0,0,0,1,0,67,0,75,0,0,0,7,0,233,0,214,0,0,0,76,0,198,0,39,0,235,0,0,0,5,0,131,0,118,0,38,0,212,0,146,0,11,0,96,0,0,0,75,0,224,0,102,0,16,0,187,0,192,0,0,0,35,0,184,0,220,0,152,0,100,0,241,0,166,0,0,0,115,0,65,0,81,0,60,0,16,0,189,0,5,0,179,0,243,0,0,0,180,0,145,0,79,0,126,0,0,0,107,0,12,0,126,0,197,0,166,0,95,0,213,0,12,0,54,0,148,0,64,0,186,0,210,0,0,0,132,0,80,0,232,0,44,0,236,0,0,0,47,0,172,0,42,0,189,0,38,0,156,0,26,0,190,0,11,0,240,0,0,0,44,0,141,0,91,0);
signal scenario_full  : scenario_type := (153,31,239,31,110,31,193,31,193,30,193,29,166,31,166,30,73,31,73,30,17,31,118,31,96,31,21,31,21,30,130,31,172,31,155,31,204,31,1,31,253,31,79,31,252,31,15,31,125,31,125,30,39,31,27,31,27,30,58,31,144,31,144,30,122,31,122,30,122,29,121,31,122,31,42,31,29,31,22,31,125,31,143,31,143,31,182,31,182,30,193,31,193,30,176,31,176,30,113,31,92,31,85,31,132,31,4,31,86,31,122,31,143,31,143,30,40,31,50,31,58,31,217,31,66,31,182,31,24,31,207,31,111,31,47,31,180,31,180,30,177,31,26,31,245,31,42,31,247,31,247,30,36,31,36,30,206,31,236,31,104,31,97,31,97,30,150,31,224,31,183,31,139,31,72,31,20,31,192,31,192,30,192,29,126,31,30,31,73,31,200,31,207,31,124,31,18,31,18,30,40,31,227,31,112,31,30,31,38,31,63,31,172,31,205,31,8,31,181,31,154,31,12,31,153,31,153,30,34,31,212,31,253,31,225,31,180,31,173,31,66,31,66,30,23,31,48,31,148,31,175,31,169,31,158,31,110,31,164,31,226,31,174,31,214,31,115,31,115,30,68,31,68,30,68,29,81,31,138,31,138,30,138,31,217,31,247,31,247,30,247,29,209,31,15,31,114,31,11,31,158,31,250,31,29,31,112,31,8,31,8,30,8,29,148,31,148,30,19,31,194,31,106,31,101,31,3,31,67,31,152,31,183,31,239,31,126,31,213,31,213,30,213,29,147,31,147,30,157,31,157,30,157,29,154,31,125,31,125,30,138,31,73,31,73,30,34,31,112,31,109,31,164,31,69,31,252,31,212,31,204,31,103,31,196,31,196,30,196,29,196,28,91,31,95,31,254,31,254,30,190,31,224,31,145,31,49,31,49,30,165,31,131,31,102,31,102,30,232,31,173,31,173,30,173,29,17,31,166,31,167,31,194,31,37,31,204,31,30,31,174,31,141,31,176,31,178,31,34,31,4,31,89,31,89,30,178,31,223,31,231,31,233,31,101,31,137,31,216,31,45,31,220,31,78,31,89,31,89,30,210,31,102,31,44,31,203,31,215,31,215,30,10,31,87,31,208,31,208,30,4,31,150,31,150,30,152,31,81,31,10,31,10,30,80,31,129,31,129,30,129,29,129,28,166,31,59,31,59,30,37,31,183,31,76,31,32,31,32,30,164,31,43,31,43,30,234,31,234,30,81,31,43,31,43,30,220,31,33,31,25,31,215,31,215,30,255,31,212,31,222,31,222,30,222,29,4,31,85,31,104,31,104,30,37,31,37,30,132,31,216,31,85,31,4,31,114,31,143,31,53,31,108,31,49,31,49,30,205,31,143,31,183,31,49,31,114,31,211,31,56,31,230,31,60,31,161,31,248,31,194,31,194,30,12,31,135,31,145,31,95,31,5,31,110,31,110,30,110,29,129,31,244,31,160,31,12,31,97,31,108,31,131,31,106,31,203,31,63,31,63,30,67,31,67,30,1,31,67,31,75,31,75,30,7,31,233,31,214,31,214,30,76,31,198,31,39,31,235,31,235,30,5,31,131,31,118,31,38,31,212,31,146,31,11,31,96,31,96,30,75,31,224,31,102,31,16,31,187,31,192,31,192,30,35,31,184,31,220,31,152,31,100,31,241,31,166,31,166,30,115,31,65,31,81,31,60,31,16,31,189,31,5,31,179,31,243,31,243,30,180,31,145,31,79,31,126,31,126,30,107,31,12,31,126,31,197,31,166,31,95,31,213,31,12,31,54,31,148,31,64,31,186,31,210,31,210,30,132,31,80,31,232,31,44,31,236,31,236,30,47,31,172,31,42,31,189,31,38,31,156,31,26,31,190,31,11,31,240,31,240,30,44,31,141,31,91,31);

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
