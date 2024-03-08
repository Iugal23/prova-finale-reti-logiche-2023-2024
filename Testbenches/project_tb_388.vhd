-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_388 is
end project_tb_388;

architecture project_tb_arch_388 of project_tb_388 is
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

constant SCENARIO_LENGTH : integer := 462;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,137,0,249,0,56,0,254,0,51,0,244,0,166,0,107,0,205,0,2,0,219,0,101,0,81,0,150,0,10,0,235,0,222,0,48,0,113,0,34,0,0,0,17,0,0,0,126,0,126,0,243,0,114,0,33,0,0,0,215,0,192,0,0,0,93,0,110,0,0,0,16,0,211,0,162,0,101,0,0,0,14,0,136,0,134,0,0,0,58,0,101,0,59,0,189,0,208,0,0,0,252,0,91,0,0,0,34,0,0,0,187,0,171,0,241,0,55,0,44,0,56,0,250,0,187,0,223,0,190,0,0,0,0,0,198,0,106,0,114,0,0,0,23,0,140,0,0,0,134,0,0,0,204,0,0,0,85,0,93,0,0,0,38,0,0,0,0,0,105,0,13,0,241,0,17,0,36,0,125,0,19,0,0,0,69,0,198,0,243,0,125,0,249,0,24,0,0,0,0,0,255,0,15,0,226,0,165,0,0,0,0,0,33,0,232,0,180,0,190,0,0,0,22,0,0,0,207,0,0,0,176,0,179,0,126,0,185,0,113,0,237,0,177,0,0,0,134,0,242,0,131,0,0,0,0,0,59,0,188,0,0,0,72,0,131,0,0,0,79,0,244,0,31,0,225,0,33,0,0,0,0,0,237,0,0,0,124,0,0,0,202,0,134,0,10,0,193,0,165,0,0,0,150,0,0,0,0,0,0,0,164,0,149,0,0,0,30,0,105,0,143,0,200,0,207,0,210,0,115,0,0,0,112,0,0,0,87,0,201,0,243,0,122,0,208,0,71,0,0,0,142,0,163,0,185,0,38,0,217,0,239,0,119,0,235,0,0,0,112,0,0,0,35,0,0,0,147,0,116,0,0,0,226,0,0,0,0,0,169,0,209,0,180,0,0,0,128,0,245,0,124,0,0,0,228,0,132,0,57,0,179,0,82,0,176,0,107,0,105,0,200,0,41,0,188,0,0,0,141,0,0,0,54,0,78,0,175,0,0,0,227,0,27,0,0,0,35,0,120,0,125,0,0,0,0,0,202,0,193,0,118,0,82,0,8,0,0,0,17,0,84,0,195,0,178,0,21,0,228,0,0,0,202,0,91,0,122,0,0,0,51,0,173,0,251,0,158,0,34,0,84,0,228,0,0,0,0,0,0,0,83,0,216,0,11,0,54,0,0,0,0,0,143,0,229,0,147,0,47,0,202,0,69,0,136,0,47,0,0,0,214,0,0,0,29,0,14,0,0,0,238,0,135,0,113,0,219,0,60,0,250,0,152,0,0,0,0,0,130,0,254,0,0,0,62,0,53,0,51,0,100,0,4,0,112,0,185,0,79,0,10,0,101,0,36,0,13,0,0,0,228,0,229,0,0,0,152,0,23,0,46,0,83,0,41,0,77,0,132,0,41,0,32,0,15,0,21,0,197,0,167,0,0,0,77,0,152,0,115,0,115,0,0,0,124,0,24,0,0,0,46,0,122,0,0,0,15,0,0,0,87,0,248,0,245,0,98,0,23,0,201,0,235,0,129,0,57,0,240,0,142,0,39,0,162,0,207,0,212,0,211,0,0,0,0,0,184,0,120,0,154,0,155,0,248,0,156,0,28,0,77,0,13,0,217,0,233,0,0,0,0,0,102,0,195,0,64,0,27,0,87,0,204,0,104,0,155,0,112,0,26,0,0,0,253,0,62,0,0,0,15,0,0,0,107,0,15,0,125,0,128,0,197,0,23,0,60,0,43,0,0,0,0,0,139,0,26,0,236,0,0,0,61,0,33,0,236,0,215,0,137,0,199,0,199,0,203,0,219,0,186,0,60,0,153,0,12,0,110,0,114,0,126,0,231,0,184,0,87,0,48,0,0,0,0,0,82,0,0,0,0,0,19,0,118,0,90,0,0,0,241,0,186,0,0,0,199,0,0,0,0,0,208,0,54,0,186,0,1,0,128,0,51,0,12,0,0,0,75,0,82,0,41,0,253,0,131,0,50,0,127,0,167,0,110,0,120,0,83,0,61,0,74,0,51,0,226,0,119,0,116,0,0,0,104,0,22,0,182,0,240,0,191,0,51,0,0,0,73,0,252,0);
signal scenario_full  : scenario_type := (0,0,137,31,249,31,56,31,254,31,51,31,244,31,166,31,107,31,205,31,2,31,219,31,101,31,81,31,150,31,10,31,235,31,222,31,48,31,113,31,34,31,34,30,17,31,17,30,126,31,126,31,243,31,114,31,33,31,33,30,215,31,192,31,192,30,93,31,110,31,110,30,16,31,211,31,162,31,101,31,101,30,14,31,136,31,134,31,134,30,58,31,101,31,59,31,189,31,208,31,208,30,252,31,91,31,91,30,34,31,34,30,187,31,171,31,241,31,55,31,44,31,56,31,250,31,187,31,223,31,190,31,190,30,190,29,198,31,106,31,114,31,114,30,23,31,140,31,140,30,134,31,134,30,204,31,204,30,85,31,93,31,93,30,38,31,38,30,38,29,105,31,13,31,241,31,17,31,36,31,125,31,19,31,19,30,69,31,198,31,243,31,125,31,249,31,24,31,24,30,24,29,255,31,15,31,226,31,165,31,165,30,165,29,33,31,232,31,180,31,190,31,190,30,22,31,22,30,207,31,207,30,176,31,179,31,126,31,185,31,113,31,237,31,177,31,177,30,134,31,242,31,131,31,131,30,131,29,59,31,188,31,188,30,72,31,131,31,131,30,79,31,244,31,31,31,225,31,33,31,33,30,33,29,237,31,237,30,124,31,124,30,202,31,134,31,10,31,193,31,165,31,165,30,150,31,150,30,150,29,150,28,164,31,149,31,149,30,30,31,105,31,143,31,200,31,207,31,210,31,115,31,115,30,112,31,112,30,87,31,201,31,243,31,122,31,208,31,71,31,71,30,142,31,163,31,185,31,38,31,217,31,239,31,119,31,235,31,235,30,112,31,112,30,35,31,35,30,147,31,116,31,116,30,226,31,226,30,226,29,169,31,209,31,180,31,180,30,128,31,245,31,124,31,124,30,228,31,132,31,57,31,179,31,82,31,176,31,107,31,105,31,200,31,41,31,188,31,188,30,141,31,141,30,54,31,78,31,175,31,175,30,227,31,27,31,27,30,35,31,120,31,125,31,125,30,125,29,202,31,193,31,118,31,82,31,8,31,8,30,17,31,84,31,195,31,178,31,21,31,228,31,228,30,202,31,91,31,122,31,122,30,51,31,173,31,251,31,158,31,34,31,84,31,228,31,228,30,228,29,228,28,83,31,216,31,11,31,54,31,54,30,54,29,143,31,229,31,147,31,47,31,202,31,69,31,136,31,47,31,47,30,214,31,214,30,29,31,14,31,14,30,238,31,135,31,113,31,219,31,60,31,250,31,152,31,152,30,152,29,130,31,254,31,254,30,62,31,53,31,51,31,100,31,4,31,112,31,185,31,79,31,10,31,101,31,36,31,13,31,13,30,228,31,229,31,229,30,152,31,23,31,46,31,83,31,41,31,77,31,132,31,41,31,32,31,15,31,21,31,197,31,167,31,167,30,77,31,152,31,115,31,115,31,115,30,124,31,24,31,24,30,46,31,122,31,122,30,15,31,15,30,87,31,248,31,245,31,98,31,23,31,201,31,235,31,129,31,57,31,240,31,142,31,39,31,162,31,207,31,212,31,211,31,211,30,211,29,184,31,120,31,154,31,155,31,248,31,156,31,28,31,77,31,13,31,217,31,233,31,233,30,233,29,102,31,195,31,64,31,27,31,87,31,204,31,104,31,155,31,112,31,26,31,26,30,253,31,62,31,62,30,15,31,15,30,107,31,15,31,125,31,128,31,197,31,23,31,60,31,43,31,43,30,43,29,139,31,26,31,236,31,236,30,61,31,33,31,236,31,215,31,137,31,199,31,199,31,203,31,219,31,186,31,60,31,153,31,12,31,110,31,114,31,126,31,231,31,184,31,87,31,48,31,48,30,48,29,82,31,82,30,82,29,19,31,118,31,90,31,90,30,241,31,186,31,186,30,199,31,199,30,199,29,208,31,54,31,186,31,1,31,128,31,51,31,12,31,12,30,75,31,82,31,41,31,253,31,131,31,50,31,127,31,167,31,110,31,120,31,83,31,61,31,74,31,51,31,226,31,119,31,116,31,116,30,104,31,22,31,182,31,240,31,191,31,51,31,51,30,73,31,252,31);

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
