-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_885 is
end project_tb_885;

architecture project_tb_arch_885 of project_tb_885 is
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

constant SCENARIO_LENGTH : integer := 520;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,183,0,168,0,235,0,37,0,211,0,135,0,168,0,209,0,28,0,192,0,222,0,167,0,0,0,0,0,103,0,7,0,5,0,0,0,203,0,252,0,0,0,250,0,95,0,0,0,20,0,215,0,107,0,79,0,228,0,84,0,232,0,3,0,35,0,148,0,0,0,242,0,223,0,188,0,202,0,20,0,218,0,200,0,214,0,94,0,0,0,114,0,174,0,71,0,242,0,202,0,140,0,191,0,246,0,201,0,11,0,41,0,231,0,62,0,226,0,51,0,19,0,211,0,0,0,164,0,171,0,145,0,192,0,0,0,102,0,79,0,225,0,198,0,121,0,0,0,83,0,208,0,0,0,0,0,242,0,0,0,196,0,0,0,0,0,27,0,123,0,131,0,148,0,208,0,151,0,0,0,134,0,73,0,16,0,27,0,53,0,3,0,159,0,138,0,63,0,171,0,136,0,34,0,37,0,58,0,0,0,0,0,208,0,2,0,0,0,115,0,0,0,15,0,5,0,206,0,13,0,79,0,77,0,96,0,180,0,0,0,151,0,219,0,125,0,235,0,75,0,0,0,233,0,66,0,97,0,0,0,80,0,0,0,0,0,227,0,105,0,98,0,103,0,0,0,219,0,39,0,7,0,96,0,159,0,9,0,144,0,0,0,146,0,145,0,137,0,217,0,75,0,64,0,246,0,33,0,10,0,50,0,0,0,0,0,68,0,56,0,0,0,184,0,53,0,10,0,70,0,239,0,242,0,92,0,0,0,110,0,82,0,30,0,220,0,0,0,0,0,20,0,0,0,201,0,255,0,118,0,36,0,7,0,0,0,169,0,159,0,46,0,208,0,76,0,0,0,128,0,113,0,100,0,225,0,253,0,41,0,106,0,0,0,97,0,125,0,248,0,235,0,50,0,0,0,198,0,0,0,99,0,111,0,0,0,112,0,231,0,58,0,167,0,31,0,210,0,221,0,66,0,32,0,80,0,0,0,154,0,121,0,0,0,21,0,247,0,32,0,0,0,216,0,200,0,59,0,41,0,121,0,210,0,206,0,217,0,181,0,181,0,115,0,198,0,34,0,125,0,241,0,252,0,15,0,42,0,0,0,219,0,89,0,159,0,121,0,209,0,188,0,69,0,255,0,213,0,146,0,108,0,253,0,248,0,88,0,188,0,191,0,122,0,240,0,188,0,226,0,208,0,0,0,219,0,81,0,54,0,149,0,142,0,223,0,238,0,0,0,228,0,21,0,84,0,0,0,103,0,220,0,0,0,209,0,178,0,212,0,100,0,0,0,0,0,29,0,30,0,54,0,241,0,182,0,120,0,0,0,68,0,0,0,0,0,61,0,103,0,213,0,173,0,0,0,64,0,0,0,0,0,0,0,73,0,55,0,141,0,0,0,0,0,169,0,0,0,154,0,99,0,128,0,59,0,36,0,49,0,185,0,202,0,154,0,0,0,54,0,0,0,0,0,16,0,174,0,56,0,232,0,52,0,0,0,134,0,214,0,0,0,0,0,72,0,194,0,186,0,17,0,67,0,232,0,193,0,153,0,81,0,243,0,0,0,7,0,0,0,62,0,254,0,34,0,140,0,107,0,39,0,11,0,119,0,61,0,240,0,72,0,13,0,0,0,162,0,72,0,0,0,225,0,0,0,81,0,0,0,184,0,207,0,29,0,8,0,48,0,159,0,0,0,0,0,168,0,0,0,222,0,46,0,57,0,182,0,122,0,120,0,55,0,131,0,193,0,6,0,213,0,87,0,80,0,163,0,20,0,219,0,203,0,27,0,0,0,98,0,78,0,31,0,178,0,0,0,115,0,21,0,0,0,110,0,0,0,29,0,125,0,47,0,160,0,0,0,51,0,245,0,43,0,208,0,111,0,8,0,160,0,0,0,55,0,143,0,0,0,64,0,162,0,201,0,0,0,0,0,2,0,10,0,221,0,0,0,62,0,253,0,69,0,0,0,119,0,172,0,246,0,71,0,0,0,225,0,0,0,119,0,142,0,0,0,64,0,10,0,5,0,166,0,239,0,31,0,133,0,82,0,21,0,34,0,237,0,41,0,248,0,87,0,254,0,0,0,136,0,197,0,168,0,95,0,94,0,200,0,0,0,0,0,60,0,0,0,184,0,5,0,0,0,0,0,0,0,192,0,174,0,1,0,21,0,0,0,11,0,248,0,117,0,161,0,12,0,156,0,163,0,0,0,0,0,45,0,246,0,9,0,232,0,32,0,114,0,46,0,20,0,225,0,238,0,210,0,0,0,0,0,238,0,25,0,250,0,206,0,71,0,0,0,235,0,118,0,18,0,169,0,1,0,102,0,222,0);
signal scenario_full  : scenario_type := (0,0,183,31,168,31,235,31,37,31,211,31,135,31,168,31,209,31,28,31,192,31,222,31,167,31,167,30,167,29,103,31,7,31,5,31,5,30,203,31,252,31,252,30,250,31,95,31,95,30,20,31,215,31,107,31,79,31,228,31,84,31,232,31,3,31,35,31,148,31,148,30,242,31,223,31,188,31,202,31,20,31,218,31,200,31,214,31,94,31,94,30,114,31,174,31,71,31,242,31,202,31,140,31,191,31,246,31,201,31,11,31,41,31,231,31,62,31,226,31,51,31,19,31,211,31,211,30,164,31,171,31,145,31,192,31,192,30,102,31,79,31,225,31,198,31,121,31,121,30,83,31,208,31,208,30,208,29,242,31,242,30,196,31,196,30,196,29,27,31,123,31,131,31,148,31,208,31,151,31,151,30,134,31,73,31,16,31,27,31,53,31,3,31,159,31,138,31,63,31,171,31,136,31,34,31,37,31,58,31,58,30,58,29,208,31,2,31,2,30,115,31,115,30,15,31,5,31,206,31,13,31,79,31,77,31,96,31,180,31,180,30,151,31,219,31,125,31,235,31,75,31,75,30,233,31,66,31,97,31,97,30,80,31,80,30,80,29,227,31,105,31,98,31,103,31,103,30,219,31,39,31,7,31,96,31,159,31,9,31,144,31,144,30,146,31,145,31,137,31,217,31,75,31,64,31,246,31,33,31,10,31,50,31,50,30,50,29,68,31,56,31,56,30,184,31,53,31,10,31,70,31,239,31,242,31,92,31,92,30,110,31,82,31,30,31,220,31,220,30,220,29,20,31,20,30,201,31,255,31,118,31,36,31,7,31,7,30,169,31,159,31,46,31,208,31,76,31,76,30,128,31,113,31,100,31,225,31,253,31,41,31,106,31,106,30,97,31,125,31,248,31,235,31,50,31,50,30,198,31,198,30,99,31,111,31,111,30,112,31,231,31,58,31,167,31,31,31,210,31,221,31,66,31,32,31,80,31,80,30,154,31,121,31,121,30,21,31,247,31,32,31,32,30,216,31,200,31,59,31,41,31,121,31,210,31,206,31,217,31,181,31,181,31,115,31,198,31,34,31,125,31,241,31,252,31,15,31,42,31,42,30,219,31,89,31,159,31,121,31,209,31,188,31,69,31,255,31,213,31,146,31,108,31,253,31,248,31,88,31,188,31,191,31,122,31,240,31,188,31,226,31,208,31,208,30,219,31,81,31,54,31,149,31,142,31,223,31,238,31,238,30,228,31,21,31,84,31,84,30,103,31,220,31,220,30,209,31,178,31,212,31,100,31,100,30,100,29,29,31,30,31,54,31,241,31,182,31,120,31,120,30,68,31,68,30,68,29,61,31,103,31,213,31,173,31,173,30,64,31,64,30,64,29,64,28,73,31,55,31,141,31,141,30,141,29,169,31,169,30,154,31,99,31,128,31,59,31,36,31,49,31,185,31,202,31,154,31,154,30,54,31,54,30,54,29,16,31,174,31,56,31,232,31,52,31,52,30,134,31,214,31,214,30,214,29,72,31,194,31,186,31,17,31,67,31,232,31,193,31,153,31,81,31,243,31,243,30,7,31,7,30,62,31,254,31,34,31,140,31,107,31,39,31,11,31,119,31,61,31,240,31,72,31,13,31,13,30,162,31,72,31,72,30,225,31,225,30,81,31,81,30,184,31,207,31,29,31,8,31,48,31,159,31,159,30,159,29,168,31,168,30,222,31,46,31,57,31,182,31,122,31,120,31,55,31,131,31,193,31,6,31,213,31,87,31,80,31,163,31,20,31,219,31,203,31,27,31,27,30,98,31,78,31,31,31,178,31,178,30,115,31,21,31,21,30,110,31,110,30,29,31,125,31,47,31,160,31,160,30,51,31,245,31,43,31,208,31,111,31,8,31,160,31,160,30,55,31,143,31,143,30,64,31,162,31,201,31,201,30,201,29,2,31,10,31,221,31,221,30,62,31,253,31,69,31,69,30,119,31,172,31,246,31,71,31,71,30,225,31,225,30,119,31,142,31,142,30,64,31,10,31,5,31,166,31,239,31,31,31,133,31,82,31,21,31,34,31,237,31,41,31,248,31,87,31,254,31,254,30,136,31,197,31,168,31,95,31,94,31,200,31,200,30,200,29,60,31,60,30,184,31,5,31,5,30,5,29,5,28,192,31,174,31,1,31,21,31,21,30,11,31,248,31,117,31,161,31,12,31,156,31,163,31,163,30,163,29,45,31,246,31,9,31,232,31,32,31,114,31,46,31,20,31,225,31,238,31,210,31,210,30,210,29,238,31,25,31,250,31,206,31,71,31,71,30,235,31,118,31,18,31,169,31,1,31,102,31,222,31);

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
