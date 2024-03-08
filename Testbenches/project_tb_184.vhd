-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_184 is
end project_tb_184;

architecture project_tb_arch_184 of project_tb_184 is
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

constant SCENARIO_LENGTH : integer := 469;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (88,0,0,0,125,0,168,0,112,0,18,0,7,0,194,0,167,0,196,0,72,0,149,0,253,0,0,0,0,0,54,0,0,0,0,0,0,0,0,0,50,0,0,0,227,0,167,0,226,0,182,0,204,0,0,0,0,0,219,0,68,0,19,0,76,0,0,0,228,0,248,0,162,0,137,0,212,0,253,0,0,0,0,0,80,0,19,0,184,0,0,0,0,0,184,0,115,0,133,0,19,0,28,0,226,0,104,0,0,0,0,0,163,0,11,0,75,0,169,0,0,0,250,0,155,0,0,0,140,0,29,0,196,0,9,0,114,0,168,0,19,0,0,0,0,0,0,0,223,0,149,0,177,0,172,0,170,0,219,0,0,0,0,0,0,0,27,0,12,0,7,0,189,0,57,0,0,0,138,0,67,0,166,0,156,0,251,0,105,0,0,0,211,0,72,0,156,0,0,0,91,0,88,0,0,0,119,0,77,0,0,0,222,0,218,0,201,0,0,0,215,0,132,0,0,0,228,0,85,0,0,0,38,0,48,0,150,0,33,0,215,0,54,0,0,0,119,0,171,0,0,0,0,0,97,0,252,0,204,0,126,0,82,0,104,0,162,0,100,0,25,0,15,0,234,0,182,0,0,0,93,0,0,0,66,0,95,0,67,0,166,0,0,0,131,0,135,0,43,0,31,0,194,0,0,0,0,0,95,0,150,0,47,0,82,0,0,0,250,0,0,0,0,0,0,0,66,0,0,0,215,0,118,0,211,0,182,0,103,0,9,0,0,0,0,0,106,0,112,0,0,0,231,0,230,0,0,0,0,0,0,0,255,0,9,0,153,0,75,0,225,0,133,0,185,0,106,0,156,0,0,0,30,0,0,0,115,0,151,0,149,0,200,0,139,0,109,0,0,0,90,0,58,0,36,0,54,0,0,0,249,0,95,0,0,0,0,0,201,0,75,0,0,0,92,0,219,0,187,0,37,0,195,0,0,0,0,0,34,0,30,0,102,0,209,0,178,0,0,0,4,0,79,0,122,0,229,0,192,0,66,0,0,0,77,0,175,0,229,0,203,0,0,0,98,0,27,0,146,0,165,0,110,0,109,0,197,0,113,0,0,0,60,0,40,0,155,0,0,0,35,0,209,0,151,0,224,0,96,0,134,0,89,0,0,0,0,0,0,0,239,0,91,0,102,0,0,0,126,0,0,0,111,0,106,0,184,0,102,0,95,0,37,0,0,0,113,0,139,0,0,0,34,0,181,0,196,0,185,0,113,0,21,0,225,0,81,0,31,0,161,0,214,0,33,0,144,0,3,0,0,0,13,0,84,0,0,0,7,0,76,0,0,0,115,0,82,0,0,0,15,0,242,0,150,0,102,0,206,0,131,0,227,0,11,0,141,0,43,0,0,0,0,0,78,0,0,0,47,0,69,0,72,0,0,0,46,0,231,0,18,0,17,0,0,0,7,0,155,0,51,0,27,0,212,0,36,0,222,0,138,0,20,0,71,0,103,0,193,0,0,0,247,0,80,0,0,0,16,0,245,0,5,0,42,0,66,0,254,0,128,0,0,0,170,0,197,0,193,0,0,0,190,0,27,0,0,0,200,0,211,0,178,0,0,0,156,0,84,0,234,0,161,0,51,0,76,0,230,0,206,0,137,0,0,0,0,0,0,0,54,0,32,0,142,0,181,0,208,0,162,0,136,0,110,0,249,0,77,0,197,0,103,0,147,0,0,0,0,0,12,0,59,0,225,0,174,0,64,0,49,0,64,0,195,0,163,0,222,0,0,0,200,0,106,0,0,0,171,0,163,0,0,0,227,0,168,0,181,0,3,0,0,0,226,0,252,0,24,0,230,0,103,0,152,0,153,0,0,0,113,0,67,0,245,0,34,0,4,0,136,0,61,0,101,0,235,0,30,0,10,0,194,0,237,0,0,0,237,0,114,0,80,0,0,0,105,0,158,0,124,0,242,0,53,0,13,0,0,0,178,0,193,0,236,0,91,0,85,0,172,0,210,0,163,0,171,0,99,0,82,0,224,0,208,0,235,0,0,0,199,0,88,0,5,0,0,0,204,0,21,0,0,0,0,0,188,0,125,0,162,0,0,0,0,0,88,0);
signal scenario_full  : scenario_type := (88,31,88,30,125,31,168,31,112,31,18,31,7,31,194,31,167,31,196,31,72,31,149,31,253,31,253,30,253,29,54,31,54,30,54,29,54,28,54,27,50,31,50,30,227,31,167,31,226,31,182,31,204,31,204,30,204,29,219,31,68,31,19,31,76,31,76,30,228,31,248,31,162,31,137,31,212,31,253,31,253,30,253,29,80,31,19,31,184,31,184,30,184,29,184,31,115,31,133,31,19,31,28,31,226,31,104,31,104,30,104,29,163,31,11,31,75,31,169,31,169,30,250,31,155,31,155,30,140,31,29,31,196,31,9,31,114,31,168,31,19,31,19,30,19,29,19,28,223,31,149,31,177,31,172,31,170,31,219,31,219,30,219,29,219,28,27,31,12,31,7,31,189,31,57,31,57,30,138,31,67,31,166,31,156,31,251,31,105,31,105,30,211,31,72,31,156,31,156,30,91,31,88,31,88,30,119,31,77,31,77,30,222,31,218,31,201,31,201,30,215,31,132,31,132,30,228,31,85,31,85,30,38,31,48,31,150,31,33,31,215,31,54,31,54,30,119,31,171,31,171,30,171,29,97,31,252,31,204,31,126,31,82,31,104,31,162,31,100,31,25,31,15,31,234,31,182,31,182,30,93,31,93,30,66,31,95,31,67,31,166,31,166,30,131,31,135,31,43,31,31,31,194,31,194,30,194,29,95,31,150,31,47,31,82,31,82,30,250,31,250,30,250,29,250,28,66,31,66,30,215,31,118,31,211,31,182,31,103,31,9,31,9,30,9,29,106,31,112,31,112,30,231,31,230,31,230,30,230,29,230,28,255,31,9,31,153,31,75,31,225,31,133,31,185,31,106,31,156,31,156,30,30,31,30,30,115,31,151,31,149,31,200,31,139,31,109,31,109,30,90,31,58,31,36,31,54,31,54,30,249,31,95,31,95,30,95,29,201,31,75,31,75,30,92,31,219,31,187,31,37,31,195,31,195,30,195,29,34,31,30,31,102,31,209,31,178,31,178,30,4,31,79,31,122,31,229,31,192,31,66,31,66,30,77,31,175,31,229,31,203,31,203,30,98,31,27,31,146,31,165,31,110,31,109,31,197,31,113,31,113,30,60,31,40,31,155,31,155,30,35,31,209,31,151,31,224,31,96,31,134,31,89,31,89,30,89,29,89,28,239,31,91,31,102,31,102,30,126,31,126,30,111,31,106,31,184,31,102,31,95,31,37,31,37,30,113,31,139,31,139,30,34,31,181,31,196,31,185,31,113,31,21,31,225,31,81,31,31,31,161,31,214,31,33,31,144,31,3,31,3,30,13,31,84,31,84,30,7,31,76,31,76,30,115,31,82,31,82,30,15,31,242,31,150,31,102,31,206,31,131,31,227,31,11,31,141,31,43,31,43,30,43,29,78,31,78,30,47,31,69,31,72,31,72,30,46,31,231,31,18,31,17,31,17,30,7,31,155,31,51,31,27,31,212,31,36,31,222,31,138,31,20,31,71,31,103,31,193,31,193,30,247,31,80,31,80,30,16,31,245,31,5,31,42,31,66,31,254,31,128,31,128,30,170,31,197,31,193,31,193,30,190,31,27,31,27,30,200,31,211,31,178,31,178,30,156,31,84,31,234,31,161,31,51,31,76,31,230,31,206,31,137,31,137,30,137,29,137,28,54,31,32,31,142,31,181,31,208,31,162,31,136,31,110,31,249,31,77,31,197,31,103,31,147,31,147,30,147,29,12,31,59,31,225,31,174,31,64,31,49,31,64,31,195,31,163,31,222,31,222,30,200,31,106,31,106,30,171,31,163,31,163,30,227,31,168,31,181,31,3,31,3,30,226,31,252,31,24,31,230,31,103,31,152,31,153,31,153,30,113,31,67,31,245,31,34,31,4,31,136,31,61,31,101,31,235,31,30,31,10,31,194,31,237,31,237,30,237,31,114,31,80,31,80,30,105,31,158,31,124,31,242,31,53,31,13,31,13,30,178,31,193,31,236,31,91,31,85,31,172,31,210,31,163,31,171,31,99,31,82,31,224,31,208,31,235,31,235,30,199,31,88,31,5,31,5,30,204,31,21,31,21,30,21,29,188,31,125,31,162,31,162,30,162,29,88,31);

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
