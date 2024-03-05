-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
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

constant SCENARIO_LENGTH : integer := 531;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (77,0,197,0,0,0,218,0,0,0,64,0,0,0,131,0,112,0,31,0,154,0,121,0,251,0,0,0,0,0,197,0,0,0,99,0,234,0,204,0,36,0,104,0,121,0,155,0,0,0,147,0,59,0,0,0,195,0,104,0,205,0,153,0,3,0,75,0,32,0,0,0,48,0,199,0,191,0,125,0,124,0,0,0,203,0,0,0,8,0,180,0,250,0,82,0,125,0,228,0,207,0,191,0,42,0,242,0,0,0,35,0,63,0,6,0,0,0,0,0,61,0,153,0,70,0,75,0,0,0,57,0,82,0,59,0,0,0,173,0,87,0,0,0,158,0,191,0,190,0,62,0,0,0,0,0,0,0,0,0,0,0,138,0,186,0,157,0,0,0,130,0,0,0,231,0,64,0,136,0,0,0,147,0,0,0,147,0,221,0,119,0,62,0,139,0,153,0,0,0,182,0,62,0,24,0,113,0,218,0,0,0,79,0,200,0,203,0,78,0,47,0,91,0,205,0,0,0,5,0,251,0,28,0,0,0,65,0,7,0,250,0,27,0,237,0,13,0,0,0,236,0,0,0,200,0,21,0,191,0,105,0,19,0,8,0,0,0,52,0,0,0,93,0,152,0,188,0,238,0,167,0,33,0,0,0,211,0,240,0,0,0,51,0,93,0,0,0,255,0,20,0,228,0,0,0,71,0,131,0,235,0,67,0,135,0,139,0,115,0,118,0,0,0,83,0,176,0,157,0,33,0,195,0,83,0,0,0,150,0,0,0,131,0,61,0,186,0,117,0,187,0,151,0,44,0,0,0,150,0,1,0,125,0,245,0,57,0,112,0,0,0,210,0,160,0,119,0,136,0,32,0,111,0,87,0,70,0,134,0,192,0,241,0,0,0,140,0,102,0,181,0,123,0,51,0,202,0,0,0,38,0,38,0,10,0,0,0,62,0,99,0,185,0,212,0,188,0,54,0,197,0,98,0,122,0,206,0,253,0,221,0,0,0,222,0,106,0,0,0,0,0,178,0,190,0,229,0,131,0,0,0,0,0,0,0,160,0,86,0,47,0,185,0,64,0,189,0,0,0,205,0,42,0,0,0,137,0,222,0,156,0,74,0,246,0,0,0,222,0,216,0,159,0,148,0,11,0,151,0,0,0,18,0,70,0,152,0,242,0,130,0,128,0,22,0,184,0,0,0,0,0,64,0,25,0,136,0,28,0,235,0,142,0,180,0,199,0,183,0,248,0,215,0,0,0,0,0,114,0,29,0,0,0,0,0,60,0,133,0,210,0,233,0,207,0,26,0,0,0,0,0,0,0,145,0,145,0,0,0,246,0,178,0,144,0,0,0,34,0,236,0,100,0,23,0,171,0,143,0,0,0,199,0,51,0,94,0,85,0,0,0,0,0,37,0,70,0,190,0,165,0,151,0,175,0,0,0,0,0,75,0,254,0,186,0,0,0,172,0,184,0,97,0,99,0,132,0,29,0,6,0,16,0,12,0,197,0,41,0,163,0,0,0,49,0,148,0,42,0,49,0,182,0,229,0,216,0,0,0,50,0,6,0,0,0,139,0,240,0,113,0,0,0,188,0,181,0,202,0,94,0,91,0,147,0,234,0,120,0,0,0,107,0,31,0,73,0,27,0,152,0,255,0,109,0,80,0,191,0,71,0,28,0,0,0,0,0,3,0,20,0,168,0,207,0,170,0,11,0,12,0,121,0,2,0,140,0,96,0,75,0,115,0,0,0,191,0,235,0,54,0,246,0,191,0,4,0,91,0,97,0,162,0,195,0,0,0,23,0,241,0,0,0,144,0,245,0,253,0,0,0,238,0,53,0,239,0,246,0,71,0,109,0,16,0,45,0,0,0,0,0,58,0,195,0,181,0,107,0,178,0,32,0,120,0,192,0,59,0,113,0,0,0,0,0,213,0,96,0,106,0,10,0,165,0,73,0,142,0,169,0,92,0,0,0,13,0,0,0,20,0,133,0,94,0,237,0,67,0,116,0,0,0,192,0,0,0,35,0,46,0,0,0,35,0,136,0,51,0,205,0,153,0,147,0,159,0,179,0,165,0,0,0,15,0,122,0,36,0,0,0,213,0,115,0,125,0,102,0,7,0,18,0,0,0,0,0,155,0,0,0,65,0,122,0,226,0,28,0,20,0,16,0,0,0,228,0,196,0,178,0,111,0,18,0,169,0,191,0,0,0,179,0,88,0,85,0,0,0,193,0,169,0,0,0,0,0,119,0,243,0,4,0,0,0,68,0,158,0,10,0,28,0,159,0,0,0,28,0,181,0,196,0,148,0,144,0,29,0,140,0,27,0,123,0,118,0,44,0,156,0,0,0,0,0,248,0,165,0,154,0,0,0,25,0,11,0,69,0,51,0);
signal scenario_full  : scenario_type := (77,31,197,31,197,30,218,31,218,30,64,31,64,30,131,31,112,31,31,31,154,31,121,31,251,31,251,30,251,29,197,31,197,30,99,31,234,31,204,31,36,31,104,31,121,31,155,31,155,30,147,31,59,31,59,30,195,31,104,31,205,31,153,31,3,31,75,31,32,31,32,30,48,31,199,31,191,31,125,31,124,31,124,30,203,31,203,30,8,31,180,31,250,31,82,31,125,31,228,31,207,31,191,31,42,31,242,31,242,30,35,31,63,31,6,31,6,30,6,29,61,31,153,31,70,31,75,31,75,30,57,31,82,31,59,31,59,30,173,31,87,31,87,30,158,31,191,31,190,31,62,31,62,30,62,29,62,28,62,27,62,26,138,31,186,31,157,31,157,30,130,31,130,30,231,31,64,31,136,31,136,30,147,31,147,30,147,31,221,31,119,31,62,31,139,31,153,31,153,30,182,31,62,31,24,31,113,31,218,31,218,30,79,31,200,31,203,31,78,31,47,31,91,31,205,31,205,30,5,31,251,31,28,31,28,30,65,31,7,31,250,31,27,31,237,31,13,31,13,30,236,31,236,30,200,31,21,31,191,31,105,31,19,31,8,31,8,30,52,31,52,30,93,31,152,31,188,31,238,31,167,31,33,31,33,30,211,31,240,31,240,30,51,31,93,31,93,30,255,31,20,31,228,31,228,30,71,31,131,31,235,31,67,31,135,31,139,31,115,31,118,31,118,30,83,31,176,31,157,31,33,31,195,31,83,31,83,30,150,31,150,30,131,31,61,31,186,31,117,31,187,31,151,31,44,31,44,30,150,31,1,31,125,31,245,31,57,31,112,31,112,30,210,31,160,31,119,31,136,31,32,31,111,31,87,31,70,31,134,31,192,31,241,31,241,30,140,31,102,31,181,31,123,31,51,31,202,31,202,30,38,31,38,31,10,31,10,30,62,31,99,31,185,31,212,31,188,31,54,31,197,31,98,31,122,31,206,31,253,31,221,31,221,30,222,31,106,31,106,30,106,29,178,31,190,31,229,31,131,31,131,30,131,29,131,28,160,31,86,31,47,31,185,31,64,31,189,31,189,30,205,31,42,31,42,30,137,31,222,31,156,31,74,31,246,31,246,30,222,31,216,31,159,31,148,31,11,31,151,31,151,30,18,31,70,31,152,31,242,31,130,31,128,31,22,31,184,31,184,30,184,29,64,31,25,31,136,31,28,31,235,31,142,31,180,31,199,31,183,31,248,31,215,31,215,30,215,29,114,31,29,31,29,30,29,29,60,31,133,31,210,31,233,31,207,31,26,31,26,30,26,29,26,28,145,31,145,31,145,30,246,31,178,31,144,31,144,30,34,31,236,31,100,31,23,31,171,31,143,31,143,30,199,31,51,31,94,31,85,31,85,30,85,29,37,31,70,31,190,31,165,31,151,31,175,31,175,30,175,29,75,31,254,31,186,31,186,30,172,31,184,31,97,31,99,31,132,31,29,31,6,31,16,31,12,31,197,31,41,31,163,31,163,30,49,31,148,31,42,31,49,31,182,31,229,31,216,31,216,30,50,31,6,31,6,30,139,31,240,31,113,31,113,30,188,31,181,31,202,31,94,31,91,31,147,31,234,31,120,31,120,30,107,31,31,31,73,31,27,31,152,31,255,31,109,31,80,31,191,31,71,31,28,31,28,30,28,29,3,31,20,31,168,31,207,31,170,31,11,31,12,31,121,31,2,31,140,31,96,31,75,31,115,31,115,30,191,31,235,31,54,31,246,31,191,31,4,31,91,31,97,31,162,31,195,31,195,30,23,31,241,31,241,30,144,31,245,31,253,31,253,30,238,31,53,31,239,31,246,31,71,31,109,31,16,31,45,31,45,30,45,29,58,31,195,31,181,31,107,31,178,31,32,31,120,31,192,31,59,31,113,31,113,30,113,29,213,31,96,31,106,31,10,31,165,31,73,31,142,31,169,31,92,31,92,30,13,31,13,30,20,31,133,31,94,31,237,31,67,31,116,31,116,30,192,31,192,30,35,31,46,31,46,30,35,31,136,31,51,31,205,31,153,31,147,31,159,31,179,31,165,31,165,30,15,31,122,31,36,31,36,30,213,31,115,31,125,31,102,31,7,31,18,31,18,30,18,29,155,31,155,30,65,31,122,31,226,31,28,31,20,31,16,31,16,30,228,31,196,31,178,31,111,31,18,31,169,31,191,31,191,30,179,31,88,31,85,31,85,30,193,31,169,31,169,30,169,29,119,31,243,31,4,31,4,30,68,31,158,31,10,31,28,31,159,31,159,30,28,31,181,31,196,31,148,31,144,31,29,31,140,31,27,31,123,31,118,31,44,31,156,31,156,30,156,29,248,31,165,31,154,31,154,30,25,31,11,31,69,31,51,31);

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
