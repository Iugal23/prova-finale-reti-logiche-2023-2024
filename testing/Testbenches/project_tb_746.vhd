-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_746 is
end project_tb_746;

architecture project_tb_arch_746 of project_tb_746 is
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

constant SCENARIO_LENGTH : integer := 431;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (109,0,200,0,152,0,0,0,210,0,178,0,122,0,177,0,0,0,237,0,0,0,70,0,52,0,152,0,97,0,152,0,50,0,216,0,223,0,151,0,0,0,0,0,43,0,87,0,0,0,115,0,56,0,154,0,208,0,2,0,147,0,93,0,19,0,34,0,20,0,176,0,110,0,60,0,227,0,0,0,140,0,31,0,205,0,3,0,0,0,128,0,78,0,175,0,31,0,4,0,172,0,36,0,0,0,131,0,97,0,93,0,54,0,0,0,103,0,196,0,39,0,0,0,58,0,100,0,53,0,143,0,253,0,229,0,124,0,9,0,0,0,59,0,167,0,121,0,52,0,160,0,47,0,229,0,0,0,0,0,0,0,0,0,0,0,216,0,0,0,238,0,0,0,149,0,199,0,0,0,58,0,86,0,227,0,228,0,39,0,0,0,0,0,9,0,128,0,179,0,192,0,0,0,191,0,224,0,248,0,161,0,0,0,67,0,0,0,16,0,129,0,98,0,0,0,32,0,166,0,55,0,127,0,214,0,0,0,31,0,213,0,0,0,0,0,123,0,0,0,68,0,175,0,21,0,184,0,168,0,85,0,244,0,0,0,253,0,21,0,0,0,151,0,0,0,70,0,218,0,186,0,0,0,119,0,13,0,155,0,0,0,152,0,190,0,112,0,77,0,0,0,0,0,0,0,243,0,0,0,53,0,0,0,179,0,109,0,0,0,167,0,2,0,0,0,51,0,247,0,170,0,181,0,219,0,180,0,226,0,182,0,87,0,0,0,114,0,130,0,0,0,191,0,225,0,61,0,204,0,95,0,79,0,157,0,136,0,0,0,33,0,0,0,74,0,137,0,0,0,234,0,27,0,150,0,150,0,0,0,5,0,197,0,42,0,108,0,180,0,56,0,22,0,57,0,30,0,83,0,0,0,0,0,59,0,216,0,113,0,36,0,47,0,113,0,3,0,177,0,212,0,138,0,105,0,210,0,146,0,100,0,0,0,198,0,112,0,145,0,0,0,0,0,63,0,0,0,0,0,141,0,162,0,7,0,47,0,0,0,0,0,16,0,0,0,239,0,76,0,188,0,203,0,221,0,0,0,113,0,0,0,0,0,1,0,115,0,1,0,82,0,139,0,240,0,0,0,7,0,0,0,36,0,0,0,216,0,0,0,188,0,195,0,182,0,113,0,0,0,120,0,138,0,0,0,204,0,0,0,193,0,20,0,43,0,0,0,0,0,171,0,0,0,77,0,143,0,245,0,80,0,81,0,133,0,131,0,105,0,0,0,149,0,145,0,10,0,0,0,0,0,236,0,146,0,156,0,202,0,192,0,173,0,239,0,97,0,186,0,125,0,22,0,14,0,162,0,0,0,126,0,174,0,40,0,135,0,97,0,34,0,57,0,212,0,162,0,96,0,64,0,0,0,0,0,14,0,119,0,248,0,21,0,118,0,137,0,216,0,29,0,194,0,35,0,51,0,62,0,240,0,101,0,223,0,0,0,221,0,38,0,154,0,201,0,69,0,248,0,0,0,24,0,106,0,118,0,78,0,35,0,0,0,170,0,215,0,119,0,78,0,43,0,241,0,211,0,161,0,13,0,141,0,53,0,0,0,71,0,0,0,112,0,134,0,26,0,104,0,131,0,145,0,166,0,239,0,173,0,0,0,188,0,12,0,242,0,199,0,0,0,200,0,21,0,146,0,245,0,0,0,120,0,111,0,34,0,0,0,205,0,170,0,18,0,0,0,159,0,217,0,0,0,0,0,131,0,130,0,139,0,65,0,236,0,115,0,138,0,36,0,212,0,0,0,26,0,136,0,85,0,0,0,37,0,185,0,203,0,0,0,53,0,230,0,247,0,0,0,143,0,158,0,15,0,46,0,224,0,156,0,119,0,206,0,102,0,80,0,242,0,97,0,174,0,117,0,177,0,91,0);
signal scenario_full  : scenario_type := (109,31,200,31,152,31,152,30,210,31,178,31,122,31,177,31,177,30,237,31,237,30,70,31,52,31,152,31,97,31,152,31,50,31,216,31,223,31,151,31,151,30,151,29,43,31,87,31,87,30,115,31,56,31,154,31,208,31,2,31,147,31,93,31,19,31,34,31,20,31,176,31,110,31,60,31,227,31,227,30,140,31,31,31,205,31,3,31,3,30,128,31,78,31,175,31,31,31,4,31,172,31,36,31,36,30,131,31,97,31,93,31,54,31,54,30,103,31,196,31,39,31,39,30,58,31,100,31,53,31,143,31,253,31,229,31,124,31,9,31,9,30,59,31,167,31,121,31,52,31,160,31,47,31,229,31,229,30,229,29,229,28,229,27,229,26,216,31,216,30,238,31,238,30,149,31,199,31,199,30,58,31,86,31,227,31,228,31,39,31,39,30,39,29,9,31,128,31,179,31,192,31,192,30,191,31,224,31,248,31,161,31,161,30,67,31,67,30,16,31,129,31,98,31,98,30,32,31,166,31,55,31,127,31,214,31,214,30,31,31,213,31,213,30,213,29,123,31,123,30,68,31,175,31,21,31,184,31,168,31,85,31,244,31,244,30,253,31,21,31,21,30,151,31,151,30,70,31,218,31,186,31,186,30,119,31,13,31,155,31,155,30,152,31,190,31,112,31,77,31,77,30,77,29,77,28,243,31,243,30,53,31,53,30,179,31,109,31,109,30,167,31,2,31,2,30,51,31,247,31,170,31,181,31,219,31,180,31,226,31,182,31,87,31,87,30,114,31,130,31,130,30,191,31,225,31,61,31,204,31,95,31,79,31,157,31,136,31,136,30,33,31,33,30,74,31,137,31,137,30,234,31,27,31,150,31,150,31,150,30,5,31,197,31,42,31,108,31,180,31,56,31,22,31,57,31,30,31,83,31,83,30,83,29,59,31,216,31,113,31,36,31,47,31,113,31,3,31,177,31,212,31,138,31,105,31,210,31,146,31,100,31,100,30,198,31,112,31,145,31,145,30,145,29,63,31,63,30,63,29,141,31,162,31,7,31,47,31,47,30,47,29,16,31,16,30,239,31,76,31,188,31,203,31,221,31,221,30,113,31,113,30,113,29,1,31,115,31,1,31,82,31,139,31,240,31,240,30,7,31,7,30,36,31,36,30,216,31,216,30,188,31,195,31,182,31,113,31,113,30,120,31,138,31,138,30,204,31,204,30,193,31,20,31,43,31,43,30,43,29,171,31,171,30,77,31,143,31,245,31,80,31,81,31,133,31,131,31,105,31,105,30,149,31,145,31,10,31,10,30,10,29,236,31,146,31,156,31,202,31,192,31,173,31,239,31,97,31,186,31,125,31,22,31,14,31,162,31,162,30,126,31,174,31,40,31,135,31,97,31,34,31,57,31,212,31,162,31,96,31,64,31,64,30,64,29,14,31,119,31,248,31,21,31,118,31,137,31,216,31,29,31,194,31,35,31,51,31,62,31,240,31,101,31,223,31,223,30,221,31,38,31,154,31,201,31,69,31,248,31,248,30,24,31,106,31,118,31,78,31,35,31,35,30,170,31,215,31,119,31,78,31,43,31,241,31,211,31,161,31,13,31,141,31,53,31,53,30,71,31,71,30,112,31,134,31,26,31,104,31,131,31,145,31,166,31,239,31,173,31,173,30,188,31,12,31,242,31,199,31,199,30,200,31,21,31,146,31,245,31,245,30,120,31,111,31,34,31,34,30,205,31,170,31,18,31,18,30,159,31,217,31,217,30,217,29,131,31,130,31,139,31,65,31,236,31,115,31,138,31,36,31,212,31,212,30,26,31,136,31,85,31,85,30,37,31,185,31,203,31,203,30,53,31,230,31,247,31,247,30,143,31,158,31,15,31,46,31,224,31,156,31,119,31,206,31,102,31,80,31,242,31,97,31,174,31,117,31,177,31,91,31);

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
